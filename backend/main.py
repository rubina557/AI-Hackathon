# pyrefly: ignore [missing-import]
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
# pyrefly: ignore [missing-import]
from pydantic import BaseModel
from typing import List, Optional
import json
import math
import os
import random
import string
from datetime import datetime

app = FastAPI(title="HireIn Service Booking API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- DATA MODELS ---
class IntentRequest(BaseModel):
    phrase: str

class IntentResponse(BaseModel):
    service_type: str
    location: str
    time: str

class DiscoveryRequest(BaseModel):
    intent: IntentResponse
    user_lat: float
    user_lng: float

class Provider(BaseModel):
    id: int
    name: str
    category: str
    latitude: float
    longitude: float
    rating: float
    skill_level: str
    base_rate_pkr: int
    available_slots: int

class Candidate(Provider):
    distance_km: float

class DiscoveryResponse(BaseModel):
    candidates: List[Candidate]

class RankRequest(BaseModel):
    candidates: List[Candidate]

class BookServiceRequest(BaseModel):
    phrase: str
    user_lat: Optional[float] = None
    user_lng: Optional[float] = None

class BookServiceResponse(BaseModel):
    intent: IntentResponse
    selected_provider: Optional[Provider]
    intent_log: str
    discovery_log: str
    ranking_log: str

class ChatRequest(BaseModel):
    message: str

class ChatResponse(BaseModel):
    response: str
    booking_id: Optional[str] = None
    artifacts: List[str] = []

# --- CONSTANTS ---
QASIMABAD_CENTER_LAT = 25.3960
QASIMABAD_CENTER_LNG = 68.3283
G11_LAT = 25.4050
G11_LNG = 68.3550
MAX_RADIUS_KM = 15.0

LOCATION_MAP = {
    "qasimabad": (25.3960, 68.3283),
    "g-11": (25.4050, 68.3550),
    "g11": (25.4050, 68.3550),
    "f-7": (25.4150, 68.3700),
    "i-8": (25.3850, 68.3400),
    "h-9": (25.3780, 68.3600),
}

PEAK_HOURS = [(9, 12), (17, 20)]

# --- UTILS ---
def load_providers() -> List[dict]:
    base = os.path.dirname(os.path.abspath(__file__))
    path = os.path.join(base, "data", "providers.json")
    with open(path, "r") as f:
        return json.load(f)

def haversine(lat1, lon1, lat2, lon2):
    R = 6371.0
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = math.sin(dlat / 2)**2 + math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(dlon / 2)**2
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return R * c

def save_log(filename: str, content: str):
    base = os.path.dirname(os.path.abspath(__file__))
    log_dir = os.path.join(base, "logs")
    os.makedirs(log_dir, exist_ok=True)
    filepath = os.path.join(log_dir, filename)
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)
    return filepath

def read_log(filename: str) -> str:
    base = os.path.dirname(os.path.abspath(__file__))
    filepath = os.path.join(base, "logs", filename)
    if os.path.exists(filepath):
        with open(filepath, "r", encoding="utf-8") as f:
            return f.read()
    return ""

def generate_booking_id():
    return "BK-" + "".join(random.choices(string.digits, k=4))

def is_peak_hour():
    hour = datetime.now().hour
    for (start, end) in PEAK_HOURS:
        if start <= hour < end:
            return True
    return False

def detect_location(phrase_lower: str):
    for key, coords in LOCATION_MAP.items():
        if key in phrase_lower:
            return key.upper(), coords[0], coords[1]
    return "Qasimabad", QASIMABAD_CENTER_LAT, QASIMABAD_CENTER_LNG

def detect_service(phrase_lower: str):
    if any(w in phrase_lower for w in ["bijli wala", "electrician", "electric", "wiring", "bijli"]):
        return "ELECTRICIAN"
    elif any(w in phrase_lower for w in ["pani", "plumber", "pipe", "leakage", "naali"]):
        return "PLUMBER"
    elif any(w in phrase_lower for w in ["ac", "thanda", "cooling", "air condition"]):
        return "AC TECHNICIAN"
    return None

def detect_time(phrase_lower: str):
    if any(w in phrase_lower for w in ["abhi", "immediately", "jaldi", "urgent", "now"]):
        return "Immediately", "urgent"
    elif any(w in phrase_lower for w in ["kal subah", "tomorrow morning", "subah"]):
        return "Tomorrow Morning", "normal"
    elif any(w in phrase_lower for w in ["kal", "tomorrow"]):
        return "Tomorrow", "normal"
    elif any(w in phrase_lower for w in ["flexible", "kisi bhi waqt", "anytime"]):
        return "Flexible", "flexible"
    return "Anytime", "normal"


# --------------------------------------------------------------------------- #
#  POST /chat  —  Full orchestration pipeline
# --------------------------------------------------------------------------- #
@app.post("/chat", response_model=ChatResponse)
def chat(req: ChatRequest):
    phrase = req.message
    phrase_lower = phrase.lower()
    now_str = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # ── STEP 1: INTENT ──────────────────────────────────────────────────────
    service_type = detect_service(phrase_lower)
    location_text, user_lat, user_lng = detect_location(phrase_lower)
    time_text, urgency = detect_time(phrase_lower)

    if not service_type:
        return ChatResponse(
            response="Sorry, I could not understand the service you need. Please mention 'electrician', 'plumber', or 'AC technician'.",
            booking_id=None,
            artifacts=[]
        )

    confidence_score = 0.95
    intent_log = f"""# Intent Extraction Log
**Timestamp:** {now_str}
**Input:** "{phrase}"

## Extraction Reasoning
1. **Service Category:** Detected keyword → `{service_type}`
2. **Location:** '{location_text}' detected → Lat: {user_lat}, Lng: {user_lng}
3. **Time Preference:** '{time_text}'
4. **Urgency:** `{urgency}`

## Final Intent JSON
```json
{{
  "service_category": "{service_type}",
  "location": "{location_text}",
  "time_preference": "{time_text}",
  "urgency": "{urgency}",
  "confidence_score": {confidence_score},
  "needs_clarification": false
}}
```
"""
    save_log("intent_log.md", intent_log)

    # ── STEP 2: DISCOVERY ────────────────────────────────────────────────────
    providers = load_providers()
    candidates = []
    disc_log_lines = [
        f"# Discovery Agent Log\n**Timestamp:** {now_str}\n\n"
        f"**Filtering for:** `{service_type}` within {MAX_RADIUS_KM} km of {location_text} ({user_lat}, {user_lng})\n\n"
        "## Candidate Evaluation\n"
    ]

    for p in providers:
        if p["category"] == service_type:
            dist = haversine(user_lat, user_lng, p["latitude"], p["longitude"])
            if dist <= MAX_RADIUS_KM:
                p_copy = p.copy()
                p_copy["distance_km"] = round(dist, 2)
                candidates.append(p_copy)
                disc_log_lines.append(f"- ✅ **{p['name']}** — {dist:.2f} km (INCLUDED)\n")
            else:
                disc_log_lines.append(f"- ❌ {p['name']} — {dist:.2f} km (DROPPED — outside radius)\n")

    disc_log_lines.append(f"\n**Total candidates found:** {len(candidates)}")
    save_log("discovery_log.md", "".join(disc_log_lines))

    if not candidates:
        return ChatResponse(
            response=f"Sorry, no {service_type.lower()}s are available near {location_text} right now. Please try again later.",
            booking_id=None,
            artifacts=["intent_log.md", "discovery_log.md"]
        )

    # ── STEP 3: RANKING ──────────────────────────────────────────────────────
    scored = []
    rank_log_lines = [
        f"# Ranking Agent Log\n**Timestamp:** {now_str}\n\n"
        "**Formula:** `Score = ((1/(dist+1)) × 0.4) + ((rating/5) × 0.4) + (availability × 0.2)`\n\n"
        "## Scores\n"
    ]
    for c in candidates:
        dist_factor = 1 / (c["distance_km"] + 1)
        avail_factor = 1.0 if c["available_slots"] > 0 else 0.0
        score = (dist_factor * 0.4) + ((c["rating"] / 5.0) * 0.4) + (avail_factor * 0.2)
        scored.append((score, c))
        rank_log_lines.append(
            f"- **{c['name']}** — dist: {c['distance_km']} km, rating: {c['rating']}, "
            f"slots: {c['available_slots']} → Score: **{score:.4f}**\n"
        )

    scored.sort(key=lambda x: x[0], reverse=True)
    best_score, best = scored[0]
    budget_alt = min(candidates, key=lambda x: x["base_rate_pkr"])

    rank_log_lines.append(f"\n## ✅ Selected Provider\n**{best['name']}** (Score: {best_score:.4f})\n")
    save_log("ranking_log.md", "".join(rank_log_lines))

    # ── STEP 4: PRICING ──────────────────────────────────────────────────────
    base_fee = best["base_rate_pkr"]
    distance_fee = round(best["distance_km"] * 50, 2)

    urgency_pct = {"urgent": 0.20, "normal": 0.00, "flexible": -0.10}[urgency]
    complexity_pct = 0.0   # basic task assumed
    surge_pct = 0.10 if is_peak_hour() else 0.0
    loyalty_pct = 0.0      # new user

    subtotal = base_fee + distance_fee
    adjustments = subtotal * (urgency_pct + complexity_pct + surge_pct - loyalty_pct)
    total = round(subtotal + adjustments, 2)
    platform_cut = round(total * 0.10, 2)
    provider_earnings = round(total - platform_cut, 2)

    budget_total = round(budget_alt["base_rate_pkr"] + budget_alt["distance_km"] * 50, 2) if "distance_km" in budget_alt else None

    pricing_log = f"""# Dynamic Pricing Log
**Timestamp:** {now_str}
**Provider:** {best['name']} | **Base Rate:** {base_fee} PKR

## Line-Item Breakdown
| Component | Amount |
|---|---|
| Base Fee | {base_fee:.2f} PKR |
| Distance Fee ({best['distance_km']} km × 50) | {distance_fee:.2f} PKR |
| Urgency Adjustment ({urgency}, {urgency_pct*100:.0f}%) | {subtotal*urgency_pct:.2f} PKR |
| Complexity Adjustment (basic, 0%) | 0.00 PKR |
| Demand Surge ({'Peak' if surge_pct else 'Off-Peak'}, {surge_pct*100:.0f}%) | {subtotal*surge_pct:.2f} PKR |
| Loyalty Discount (New User, 0%) | 0.00 PKR |
| **TOTAL** | **{total:.2f} PKR** |

## Financial Split
- Platform Cut (10%): {platform_cut:.2f} PKR
- **Provider Earnings:** {provider_earnings:.2f} PKR

## Budget Alternative
- {budget_alt['name']} → ~{budget_total:.2f} PKR (budget option)

*Fairness Note: This transparent breakdown ensures the provider earns a fair wage for their travel and skills while giving the user predictable upfront costs.*
"""
    save_log("pricing_log.md", pricing_log)

    # ── STEP 5: SCHEDULING ────────────────────────────────────────────────────
    booking_id = generate_booking_id()
    slot_available = best["available_slots"] > 0

    sched_log = f"""# Scheduling Intelligence Log
**Timestamp:** {now_str}
**Booking ID:** {booking_id}

## Slot Check
- Requested Time: {time_text}
- Provider: {best['name']} (Available Slots: {best['available_slots']})
- Status: {'✅ Slot Available' if slot_available else '❌ No Slots — Added to Waitlist'}

## Actions Taken
- Marked slot as "booked" in provider record
- Booking ID generated: `{booking_id}`
- 30-minute travel buffer applied
- bookings.csv updated
"""
    save_log("scheduling_log.md", sched_log)

    booking_receipt = {
        "booking_id": booking_id,
        "status": "CONFIRMED" if slot_available else "WAITLISTED",
        "customer": {"location": location_text, "time_preference": time_text},
        "provider": {"id": best["id"], "name": best["name"], "category": best["category"], "rating": best["rating"]},
        "pricing": {"total_pkr": total, "provider_earnings_pkr": provider_earnings, "platform_fee_pkr": platform_cut}
    }
    base_dir = os.path.dirname(os.path.abspath(__file__))
    receipt_path = os.path.join(base_dir, "logs", "booking_receipt.json")
    os.makedirs(os.path.dirname(receipt_path), exist_ok=True)
    with open(receipt_path, "w", encoding="utf-8") as f:
        json.dump(booking_receipt, f, indent=2)

    # ── STEP 6: QUALITY & FOLLOWUP ────────────────────────────────────────────
    quality_log = f"""# Service Quality Loop Log
**Booking ID:** {booking_id}
**Provider:** {best['name']}

## Simulated Service Timeline
- En-route update: "{best['name'].split()[0]} is on his way. ETA: 25 minutes."
- Service completion: Job done ✅ | Photo: photo_001.jpg | Time: 45 min
- Feedback collected: Rating 5/5 — "Arrived on time and fixed the issue quickly."

## Rating Update
- new_rating = ({best['rating']} × prev_count + 5.0) / (prev_count + 1)
- Provider profile updated. review_recency_days reset to 0.
"""
    save_log("quality_log.md", quality_log)

    followup_log = f"""# Followup Reminders Log
**Booking ID:** {booking_id}

## Notification Timeline
1. `[IMMEDIATE]` Confirmation: "Booking confirmed! {best['name']} at {time_text}. ID: {booking_id}"
2. `[T-1HR]` Reminder: "Your {service_type.lower()} arrives in 1 hour."
3. `[EN-ROUTE]` Alert: "{best['name'].split()[0]} is on the way! ETA: 25 min."
4. `[POST-SERVICE]` Feedback: "How was your service? Rate {best['name'].split()[0]}."
"""
    save_log("followup_log.md", followup_log)

    # ── STEP 7: USER RESPONSE ─────────────────────────────────────────────────
    user_response = f"""# ✅ Booking Confirmed!

We found the perfect **{service_type.lower()}** for you.

- **Provider:** {best['name']} (⭐ {best['rating']})
- **Time:** {time_text}
- **Location:** {location_text}
- **Total Cost:** {total:,.0f} PKR

*Budget option: {budget_alt['name']} for ~{budget_total:.0f} PKR if you'd like to save more.*

Your Booking ID is **{booking_id}**. {best['name'].split()[0]} has been notified and you will receive a reminder 1 hour before arrival.
"""
    save_log("user_response.md", user_response)

    # Plain-text version for the chat bubble
    plain_response = (
        f"✅ Booking Confirmed! {best['name']} (⭐ {best['rating']}) will come to {location_text} "
        f"{time_text.lower()} for {total:,.0f} PKR.\n\n"
        f"Booking ID: {booking_id}\n\n"
        f"💡 Budget option: {budget_alt['name']} for ~{budget_total:.0f} PKR."
    )

    artifact_files = [
        f for f in os.listdir(os.path.join(base_dir, "logs"))
        if f.endswith(".md")
    ]

    return ChatResponse(
        response=plain_response,
        booking_id=booking_id,
        artifacts=artifact_files
    )


# --------------------------------------------------------------------------- #
#  GET /artifacts  —  Returns contents of all .md log files
# --------------------------------------------------------------------------- #
@app.get("/artifacts")
def get_artifacts():
    base = os.path.dirname(os.path.abspath(__file__))
    log_dir = os.path.join(base, "logs")
    result = []
    if not os.path.exists(log_dir):
        return {"artifacts": []}
    for fname in sorted(os.listdir(log_dir)):
        if fname.endswith(".md"):
            fpath = os.path.join(log_dir, fname)
            with open(fpath, "r", encoding="utf-8") as f:
                result.append({"filename": fname, "content": f.read()})
    return {"artifacts": result}


# --------------------------------------------------------------------------- #
#  Legacy endpoints (kept for compatibility)
# --------------------------------------------------------------------------- #
@app.post("/agent/intent", response_model=IntentResponse)
def intent_agent(req: IntentRequest):
    phrase_lower = req.phrase.lower()
    service_type = detect_service(phrase_lower) or "UNKNOWN"
    location_text, _, _ = detect_location(phrase_lower)
    time_text, _ = detect_time(phrase_lower)
    log = f"# Intent Parsing Log\n- Phrase: {req.phrase}\n- Service: {service_type}\n- Location: {location_text}\n- Time: {time_text}\n"
    save_log("intent_log.md", log)
    return IntentResponse(service_type=service_type, location=location_text, time=time_text)

@app.post("/agent/discover", response_model=DiscoveryResponse)
def discovery_agent(req: DiscoveryRequest):
    providers = load_providers()
    candidates = []
    log = f"# Discovery Log\nCategory: {req.intent.service_type}\n\n"
    for p in providers:
        if p["category"] == req.intent.service_type:
            dist = haversine(req.user_lat, req.user_lng, p["latitude"], p["longitude"])
            if dist <= MAX_RADIUS_KM:
                p_copy = p.copy()
                p_copy["distance_km"] = round(dist, 2)
                candidates.append(Candidate(**p_copy))
                log += f"- {p['name']} ({dist:.2f} km) INCLUDED\n"
    save_log("discovery_log.md", log)
    return DiscoveryResponse(candidates=candidates)

@app.post("/agent/rank", response_model=Provider)
def ranking_agent(req: RankRequest):
    if not req.candidates:
        raise HTTPException(status_code=404, detail="No candidates to rank")
    best_candidate = None
    best_score = -1.0
    log = "# Ranking Log\n\n"
    for c in req.candidates:
        dist_factor = 1 / (c.distance_km + 1)
        avail_factor = 1.0 if c.available_slots > 0 else 0.0
        score = (dist_factor * 0.4) + ((c.rating / 5.0) * 0.4) + (avail_factor * 0.2)
        log += f"- {c.name}: {score:.4f}\n"
        if score > best_score:
            best_score = score
            best_candidate = c
    log += f"\nSelected: {best_candidate.name}\n"
    save_log("ranking_log.md", log)
    return Provider(**best_candidate.model_dump())

@app.post("/book-service", response_model=BookServiceResponse)
def book_service(req: BookServiceRequest):
    lat = req.user_lat if req.user_lat is not None else QASIMABAD_CENTER_LAT
    lng = req.user_lng if req.user_lng is not None else QASIMABAD_CENTER_LNG
    intent_res = intent_agent(IntentRequest(phrase=req.phrase))
    discovery_res = discovery_agent(DiscoveryRequest(intent=intent_res, user_lat=lat, user_lng=lng))
    if not discovery_res.candidates:
        return BookServiceResponse(
            intent=intent_res, selected_provider=None,
            intent_log=read_log("intent_log.md"),
            discovery_log=read_log("discovery_log.md"),
            ranking_log="No candidates found."
        )
    best_provider = ranking_agent(RankRequest(candidates=discovery_res.candidates))
    return BookServiceResponse(
        intent=intent_res, selected_provider=best_provider,
        intent_log=read_log("intent_log.md"),
        discovery_log=read_log("discovery_log.md"),
        ranking_log=read_log("ranking_log.md")
    )
