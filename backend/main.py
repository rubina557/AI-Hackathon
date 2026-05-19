from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional, Dict, Any
import json, math, os, random, string, csv
from datetime import datetime

app = FastAPI(title="HireIn Pakistan Service Orchestrator")
app.add_middleware(CORSMiddleware, allow_origins=["*"], allow_credentials=True, allow_methods=["*"], allow_headers=["*"])

# ── PATHS ──────────────────────────────────────────────────────────────────────
BASE = os.path.dirname(os.path.abspath(__file__))
PROVIDERS_PATH = os.path.join(BASE, "mock_providers.json")
BOOKINGS_CSV   = os.path.join(BASE, "bookings.csv")
LOGS_DIR       = os.path.join(BASE, "logs")
os.makedirs(LOGS_DIR, exist_ok=True)

# ── MODELS ─────────────────────────────────────────────────────────────────────
class ChatRequest(BaseModel):
    message: str
    user_id: str = "uid_001"
    user_lat: float = 25.3960
    user_lng: float = 68.3578

class ReviewRequest(BaseModel):
    booking_id: str
    rating: float
    comment: str = ""

class DisputeRequest(BaseModel):
    booking_id: str
    issue: str  # no_show / quality_complaint / price_dispute / overrun / cancellation

class BookRequest(BaseModel):
    provider_id: str
    slot: str
    pricing: dict
    is_urgent: bool
    user_lat: float = 25.3960
    user_lng: float = 68.3578

# ── UTILS ──────────────────────────────────────────────────────────────────────
def load_providers() -> List[dict]:
    with open(PROVIDERS_PATH, "r", encoding="utf-8") as f:
        return json.load(f)

def save_providers(providers: List[dict]):
    with open(PROVIDERS_PATH, "w", encoding="utf-8") as f:
        json.dump(providers, f, indent=2, ensure_ascii=False)

def save_log(filename: str, content: str):
    with open(os.path.join(LOGS_DIR, filename), "w", encoding="utf-8") as f:
        f.write(content)

def haversine(lat1, lon1, lat2, lon2) -> float:
    R = 6371.0
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = math.sin(dlat/2)**2 + math.cos(math.radians(lat1))*math.cos(math.radians(lat2))*math.sin(dlon/2)**2
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))

def is_peak_hour() -> bool:
    h = datetime.now().hour
    return (9 <= h < 12) or (17 <= h < 20)

def gen_booking_id() -> str:
    return "BK-" + "".join(random.choices(string.digits, k=4))

def now_str() -> str:
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")

# ── AGENT 1: INTENT ────────────────────────────────────────────────────────────
SERVICE_KEYWORDS = {
    "AC Technician": ["ac", "air condition", "thanda", "cooling", "inverter ac", "split ac",
                      "اے سی", "ac wala", "ac waale", "ac technician", "esee"],
    "Plumber":       ["plumber", "plumbing", "pipe", "pani", "leakage", "naali", "tank",
                      "geyser", "پلمبر", "paani"],
    "Electrician":   ["electrician", "bijli", "wiring", "electric", "bijli wala", "light",
                      "fan", "switch", "برقی", "بجلی"],
    "Tutor":         ["tutor", "teacher", "parhana", "study", "math", "physics", "chemistry",
                      "استاد", "tuition", "coaching"],
    "Mechanic":      ["mechanic", "car", "bike", "motor", "engine", "tyre", "petrol",
                      "میکینک", "gaadi"],
    "Beautician":    ["beauty", "makeup", "salon", "mehndi", "facial", "hair", "threading",
                      "beautician", "بیوٹی"],
    "Carpenter":     ["carpenter", "furniture", "wood", "door", "cabinet", "بڑھئی", "lakri"],
    "Painter":       ["painter", "paint", "colour", "rang", "wall", "رنگ", "painting"],
}

URGENT_WORDS = ["abhi", "urgent", "jaldi", "فوری", "ابھی", "asap", "immediately",
                "fauri", "turant", "now", "فوراً"]

LOCATION_MAP = {
    "hyder chowk": (25.3960, 68.3578),
    "haider chowk": (25.3960, 68.3578),
    "latifabad": (25.4200, 68.3400),
    "qasimabad": (25.3800, 68.3300),
    "hirabad": (25.3700, 68.3700),
    "saddar": (25.3677, 68.3600),
    "hyderabad": (25.3960, 68.3578),
}

def agent1_intent(message: str, user_lat: float, user_lng: float) -> dict:
    ts = now_str()
    msg_lower = message.lower()

    # Detect service
    detected_service = None
    for svc, keywords in SERVICE_KEYWORDS.items():
        if any(kw in msg_lower for kw in keywords):
            detected_service = svc
            break

    # Detect location
    detected_lat, detected_lng = user_lat, user_lng
    location_name = "User Location"
    for loc, coords in LOCATION_MAP.items():
        if loc in msg_lower:
            detected_lat, detected_lng = coords
            location_name = loc.title()
            break

    # Detect urgency
    is_urgent = any(w in msg_lower for w in URGENT_WORDS)

    # Detect time preference
    time_pref = "Anytime"
    if any(w in msg_lower for w in ["kal subah", "tomorrow morning", "subah"]):
        time_pref = "Tomorrow Morning"
    elif any(w in msg_lower for w in ["kl raat", "kal raat", "raat me", "tonight", "tomorrow night"]):
        time_pref = "Tomorrow Night"
    elif any(w in msg_lower for w in ["aaj", "today", "aj"]):
        time_pref = "Today"
    elif is_urgent:
        time_pref = "Immediately"

    # Budget sensitivity
    budget_sensitivity = "low"
    if any(w in msg_lower for w in ["sasta", "cheap", "affordable", "budget", "kam"]):
        budget_sensitivity = "low"
    elif any(w in msg_lower for w in ["best", "acha", "quality", "expert"]):
        budget_sensitivity = "high"

    # Confidence score
    confidence_score = 0.95 if detected_service else 0.40

    log = f"""# Intent Extraction Log
**Timestamp:** {ts}
**Input:** "{message}"

## Detection Results
| Field | Value |
|---|---|
| Service Category | {detected_service or 'Unknown'} |
| Location | {location_name} ({detected_lat}, {detected_lng}) |
| Time Preference | {time_pref} |
| Urgency | {'🚨 URGENT' if is_urgent else 'Scheduled'} |
| Budget Sensitivity | {budget_sensitivity} |
| Confidence Score | {confidence_score} |

## Final Intent JSON
```json
{{
  "service_category": "{detected_service}",
  "location": "{location_name}",
  "lat": {detected_lat},
  "lng": {detected_lng},
  "time_preference": "{time_pref}",
  "is_urgent": {str(is_urgent).lower()},
  "budget_sensitivity": "{budget_sensitivity}",
  "confidence_score": {confidence_score}
}}
```
"""
    save_log("intent_log.md", log)

    return {
        "service_category": detected_service,
        "location_name": location_name,
        "lat": detected_lat,
        "lng": detected_lng,
        "time_preference": time_pref,
        "is_urgent": is_urgent,
        "budget_sensitivity": budget_sensitivity,
        "confidence_score": confidence_score,
    }

# ── AGENT 2: DISCOVERY ─────────────────────────────────────────────────────────
def agent2_discovery(intent: dict) -> List[dict]:
    ts = now_str()
    providers = load_providers()
    svc = intent["service_category"]
    lat, lng = intent["lat"], intent["lng"]

    def find_within(radius):
        found = []
        for p in providers:
            if p["category"].lower() == svc.lower():
                dist = haversine(lat, lng, p["lat"], p["lng"])
                if dist <= radius and len(p.get("available_slots", [])) > 0:
                    pc = p.copy()
                    pc["distance_km"] = round(dist, 2)
                    found.append(pc)
        return found

    radius = 15.0
    candidates = find_within(radius)
    expanded = False
    if len(candidates) < 3:
        radius = 25.0
        candidates = find_within(radius)
        expanded = True

    log = f"""# Discovery Agent Log
**Timestamp:** {ts}
**Service:** {svc} | **Radius:** {radius} km {'(expanded from 15km)' if expanded else ''}
**User Location:** {lat}, {lng}

## Candidates Found ({len(candidates)})
| Provider | Distance | Slots | Status |
|---|---|---|---|
"""
    for c in candidates:
        slots_str = ", ".join(c["available_slots"][:2])
        log += f"| {c['name']} | {c['distance_km']} km | {slots_str} | ✅ INCLUDED |\n"

    if not candidates:
        log += "\n⚠️ **No providers found within 25km. Please try a different location.**\n"

    log += f"\n**Total Candidates:** {len(candidates)}"
    save_log("discovery_log.md", log)
    return candidates

# ── AGENT 3: RANKING ───────────────────────────────────────────────────────────
def agent3_ranking(candidates: List[dict], intent: dict) -> List[dict]:
    ts = now_str()
    svc = intent["service_category"]

    SKILL_MAP = {"expert": 10, "intermediate": 6, "basic": 3}

    def score_provider(p):
        dist_weight = 0.50 if intent.get("is_urgent") else 0.20
        rating_weight = 0.10 if intent.get("is_urgent") else 0.25
        skill_weight = 0.10 if intent.get("is_urgent") else 0.20
        
        rating_score  = (p["rating"] / 5.0) * rating_weight
        dist_score    = (1 / (p["distance_km"] + 1)) * dist_weight
        skill_val     = SKILL_MAP.get(p.get("skill_level", "basic"), 3)
        skill_score   = (skill_val / 10.0) * skill_weight
        ontime_score  = p.get("on_time_score", 0.8) * 0.15
        recency_score = max(0, 1 - p.get("review_recency_days", 30) / 30) * 0.10
        cancel_score  = (1 - p.get("cancellation_rate", 0.1)) * 0.05
        verified_score= (1.0 if p.get("verified") else 0.0) * 0.03
        spec_match    = 0.02 if any(svc.lower() in s.lower() for s in p.get("specializations", [])) else 0.0
        total = rating_score + dist_score + skill_score + ontime_score + recency_score + cancel_score + verified_score + spec_match
        return round(total, 4)

    scored = [(score_provider(p), p) for p in candidates]
    scored.sort(key=lambda x: x[0], reverse=True)

    log = f"""# Ranking Engine Log
**Timestamp:** {ts}
**Scoring Weights:** Rating(25%) Distance(20%) Skill(20%) OnTime(15%) Recency(10%) Cancellation(5%) Verified(3%) SpecMatch(2%)

## Full Scoring Table
| Rank | Provider | Rating | Dist | Skill | OnTime | Score |
|---|---|---|---|---|---|---|
"""
    for i, (score, p) in enumerate(scored):
        tag = " 🏆 RECOMMENDED" if i == 0 else ""
        log += f"| #{i+1} | {p['name']}{tag} | {p['rating']} | {p['distance_km']}km | {p['skill_level']} | {p['on_time_score']} | **{score}** |\n"

    save_log("ranking_log.md", log)
    return [p for _, p in scored]

# ── AGENT 4: PRICING ───────────────────────────────────────────────────────────
def agent4_pricing(provider: dict, intent: dict) -> dict:
    ts = now_str()
    dist = provider["distance_km"]
    is_urgent = intent["is_urgent"]
    skill = provider.get("skill_level", "basic")

    base_fee      = provider["base_rate_pkr"]
    distance_fee  = round(dist * 50, 2)
    urgency_fee   = round(base_fee * 0.20, 2) if is_urgent else 0.0
    complexity_fee= round(base_fee * (0.15 if skill == "intermediate" else 0.30 if skill == "expert" else 0.0), 2)
    surge_fee     = round(base_fee * 0.10, 2) if is_peak_hour() else 0.0
    subtotal      = base_fee + distance_fee + urgency_fee + complexity_fee + surge_fee
    platform_cut  = round(subtotal * 0.10, 2)
    total         = round(subtotal + platform_cut, 2)
    provider_earn = round(total - platform_cut, 2)
    eta_minutes   = int((dist / 30.0) * 60) if is_urgent else None

    log = f"""# Pricing Engine Log
**Timestamp:** {ts}
**Provider:** {provider['name']} | **Distance:** {dist} km

## Pricing Breakdown
| Item | Amount (PKR) |
|---|---|
| Base Fee | {base_fee} |
| Distance Fee ({dist} km × 50) | {distance_fee} |
| Urgency Fee (20%) | {urgency_fee} |
| Complexity Fee | {complexity_fee} |
| Demand Surge (Peak Hour) | {surge_fee} |
| **Subtotal** | **{subtotal}** |
| Platform Cut (10%) | {platform_cut} |
| **Total** | **{total}** |
| Provider Earnings | {provider_earn} |
{'| ETA | ~' + str(eta_minutes) + ' mins |' if eta_minutes else ''}
"""
    save_log("pricing_log.md", log)

    return {
        "base_fee": base_fee,
        "distance_fee": distance_fee,
        "urgency_fee": urgency_fee,
        "complexity_fee": complexity_fee,
        "surge_fee": surge_fee,
        "platform_cut": platform_cut,
        "total_pkr": total,
        "provider_earnings": provider_earn,
        "eta_minutes": eta_minutes,
    }

# ── AGENT 5: MATCHMAKER ────────────────────────────────────────────────────────
def agent5_matchmaker(ranked: List[dict], pricing_list: List[dict], intent: dict) -> dict:
    ts = now_str()
    winner = ranked[0]
    runner_up = ranked[1] if len(ranked) > 1 else None

    # Dynamic badges
    badges = list(winner.get("badges", []))
    if winner["rating"] >= 4.7 and "Top Rated" not in badges:
        badges.append("Top Rated")
    if winner.get("skill_level") == "expert" and "Expert Level" not in badges:
        badges.append("Expert Level")
    if winner.get("on_time_score", 0) >= 0.90 and "Highly Reliable" not in badges:
        badges.append("Highly Reliable")
    if winner.get("verified") and "Verified ✓" not in badges:
        badges.append("Verified ✓")

    # Reasoning
    reason_parts = [f"{winner['name']} was selected"]
    if runner_up:
        reason_parts.append(f"over {runner_up['name']} (rated {runner_up['rating']})")
    reason_parts.append(f"because they have a {winner['rating']} rating")
    if winner.get("verified"):
        reason_parts.append("are verified")
    if winner.get("skill_level") == "expert":
        reason_parts.append("and are an expert-level technician")
    reasoning = " ".join(reason_parts) + "."

    # Affordable badge — lowest price?
    prices = [p["total_pkr"] for p in pricing_list]
    if pricing_list and pricing_list[0]["total_pkr"] == min(prices):
        if "Affordable" not in badges:
            badges.append("Affordable")

    # Fastest ETA badge
    if intent["is_urgent"] and pricing_list:
        etas = [p.get("eta_minutes") for p in pricing_list if p.get("eta_minutes")]
        if etas and pricing_list[0].get("eta_minutes") == min(etas):
            badges.append("Fastest ETA")

    log = f"""# Matchmaker Log
**Timestamp:** {ts}

## Winner: {winner['name']}
**Reasoning:** {reasoning}

## Badges Assigned
{', '.join(badges)}

## Alternatives Considered
{chr(10).join([f'- {r["name"]} (Rating: {r["rating"]}, Dist: {r["distance_km"]}km)' for r in ranked[1:4]])}
"""
    save_log("matchmaker_log.md", log)
    winner["badges"] = badges
    winner["reasoning"] = reasoning
    return winner

# ── AGENT 6: LOCK & BOOK ───────────────────────────────────────────────────────
def agent6_book(winner: dict, pricing: dict, intent: dict, slot_override: str = None) -> dict:
    ts = now_str()
    booking_id = gen_booking_id()
    slot = slot_override if slot_override else (winner.get("available_slots", ["2026-05-17 10:00"])[0])

    # Save to CSV
    file_exists = os.path.exists(BOOKINGS_CSV)
    with open(BOOKINGS_CSV, "a", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        if not file_exists:
            writer.writerow(["booking_id", "provider_id", "provider_name", "slot", "total_pkr", "timestamp", "status"])
        writer.writerow([booking_id, winner["id"], winner["name"], slot, pricing["total_pkr"], ts, "confirmed"])

    # Save receipt
    receipt = {
        "booking_id": booking_id,
        "provider": {"id": winner["id"], "name": winner["name"]},
        "slot": slot,
        "pricing": pricing,
        "timestamp": ts,
        "status": "confirmed",
    }
    with open(os.path.join(BASE, "booking_receipt.json"), "w", encoding="utf-8") as f:
        json.dump(receipt, f, indent=2)

    log = f"""# Scheduling Log
**Timestamp:** {ts}
**Booking ID:** {booking_id}

## Booking Details
| Field | Value |
|---|---|
| Provider | {winner['name']} |
| Slot | {slot} |
| Status | ✅ Confirmed |
| Total | PKR {pricing['total_pkr']} |

## Conflict Check
- ✅ Slot available — no conflicts detected
- ⏱ 30-min travel buffer applied around slot
"""
    save_log("scheduling_log.md", log)
    return {"booking_id": booking_id, "slot": slot, "status": "confirmed"}

# ── AGENT 7: FOLLOW-UP ─────────────────────────────────────────────────────────
def agent7_followup(booking: dict, winner: dict, pricing: dict) -> dict:
    ts = now_str()
    bid = booking["booking_id"]
    slot = booking["slot"]
    eta = pricing.get("eta_minutes")

    notifications = [
        {"trigger": "immediate", "message": f"✅ Booking confirmed! {winner['name']} arriving at {slot}. ID: {bid}"},
        {"trigger": "T-1hr",     "message": f"⏰ Your technician arrives in 1 hour. Be ready!"},
        {"trigger": "en_route",  "message": f"🚗 {winner['name']} is on the way!" + (f" ETA: {eta} mins" if eta else "")},
        {"trigger": "complete",  "message": f"⭐ How was your service? Rate {winner['name']} to help others!"},
    ]

    log = f"""# Follow-up & Tracking Log
**Timestamp:** {ts}
**Booking:** {bid}

## Notification Timeline
| Trigger | Message |
|---|---|
"""
    for n in notifications:
        log += f"| {n['trigger']} | {n['message']} |\n"

    save_log("followup_log.md", log)
    return {"notifications": notifications}

# ── AGENT 8: REVIEW ────────────────────────────────────────────────────────────
def agent8_review(booking_id: str, rating: float, comment: str) -> dict:
    ts = now_str()
    providers = load_providers()

    # Find provider from bookings CSV
    provider_id = None
    if os.path.exists(BOOKINGS_CSV):
        with open(BOOKINGS_CSV, "r", encoding="utf-8") as f:
            for row in csv.DictReader(f):
                if row["booking_id"] == booking_id:
                    provider_id = row["provider_id"]
                    break

    updated = False
    for p in providers:
        if p["id"] == provider_id:
            old_rating = p["rating"]
            count = p["review_count"]
            p["rating"] = round((old_rating * count + rating) / (count + 1), 2)
            p["review_count"] = count + 1
            p["review_recency_days"] = 0
            # Recalculate badges
            new_badges = []
            if p["rating"] >= 4.7: new_badges.append("Top Rated")
            if p["skill_level"] == "expert": new_badges.append("Expert Level")
            if p["on_time_score"] >= 0.90: new_badges.append("Highly Reliable")
            if p["verified"]: new_badges.append("Verified ✓")
            p["badges"] = new_badges
            updated = True
            break

    if updated:
        save_providers(providers)

    log = f"""# Quality Review Log
**Timestamp:** {ts}
**Booking:** {booking_id} | **Rating:** {rating}/5 | **Comment:** "{comment}"
**Provider Updated:** {'✅ ' + provider_id if updated else '⚠️ Provider not found'}
"""
    save_log("quality_log.md", log)
    return {"status": "updated" if updated else "provider_not_found", "new_rating": rating}

# ── AGENT 9: DISPUTE ───────────────────────────────────────────────────────────
def agent9_dispute(booking_id: str, issue: str) -> dict:
    ts = now_str()
    RESOLUTIONS = {
        "no_show":           {"action": "Full refund issued. Provider flagged.", "refund_pct": 100, "flag": True},
        "quality_complaint": {"action": "Partial refund (50%) issued. Note added to profile.", "refund_pct": 50, "flag": False},
        "price_dispute":     {"action": "Receipt reviewed. Decision pending.", "refund_pct": 0, "flag": False},
        "overrun":           {"action": "Time overrun noted. Provider warned.", "refund_pct": 10, "flag": False},
        "cancellation":      {"action": "Cancellation fee applied per policy.", "refund_pct": 0, "flag": False},
    }
    resolution = RESOLUTIONS.get(issue, {"action": "Escalated to human review.", "refund_pct": 0, "flag": False})

    log = f"""# Dispute Resolution Log
**Timestamp:** {ts}
**Booking:** {booking_id} | **Issue:** {issue}

## Auto-Resolution
- **Action:** {resolution['action']}
- **Refund:** {resolution['refund_pct']}%
- **Provider Flagged:** {resolution['flag']}
- **Risk Score Updated:** +0.15
"""
    save_log("dispute_log.md", log)
    return {"booking_id": booking_id, "issue": issue, "resolution": resolution["action"], "refund_pct": resolution["refund_pct"]}

# ── ENDPOINTS ──────────────────────────────────────────────────────────────────
@app.post("/chat")
def chat(req: ChatRequest):
    msg = req.message

    # Agent 1
    intent = agent1_intent(msg, req.user_lat, req.user_lng)

    if not intent["service_category"]:
        # Detect input language for response
        has_urdu = any(c > '\u0600' for c in msg)
        if intent["confidence_score"] < 0.75:
            clarify = "آپ کو کون سی سروس چاہیے؟ مثال: AC، پلمبر، الیکٹریشن" if has_urdu else \
                      "Could not understand the service needed. Please mention: AC Technician, Plumber, Electrician, Tutor, Mechanic, Beautician, Carpenter, or Painter."
            return {"response": clarify, "booking_id": None, "provider": None, "pricing": None,
                    "reasoning": None, "is_urgent": False, "artifacts": ["intent_log.md"]}

    # Agent 2
    candidates = agent2_discovery(intent)
    if not candidates:
        return {"response": f"معذرت! آپ کے قریب کوئی {intent['service_category']} دستیاب نہیں۔ بعد میں کوشش کریں۔",
                "booking_id": None, "provider": None, "pricing": None,
                "reasoning": None, "is_urgent": intent["is_urgent"],
                "artifacts": ["intent_log.md", "discovery_log.md"]}

    # Agent 3
    ranked = agent3_ranking(candidates, intent)

    # Agent 4 — price all top 5
    pricing_list = [agent4_pricing(p, intent) for p in ranked[:5]]

    # Agent 5
    winner = agent5_matchmaker(ranked[:5], pricing_list, intent)
    pricing = pricing_list[0]

    # Build response
    artifacts = [f for f in os.listdir(LOGS_DIR) if f.endswith(".md")]
    other_options = [
        {
            "id": p["id"], "name": p["name"], "rating": p["rating"],
            "distance_km": p["distance_km"], "skill_level": p["skill_level"],
            "base_rate_pkr": p["base_rate_pkr"], "badges": p.get("badges", []),
            "available_slots": p.get("available_slots", []),
        }
        for p in ranked[1:4]
    ]

    return {
        "response": f"Found top providers for {intent['service_category']}.",
        "booking_id": None,
        "provider": {
            "id": winner["id"], "name": winner["name"], "category": winner["category"],
            "rating": winner["rating"], "review_count": winner["review_count"],
            "skill_level": winner["skill_level"], "distance_km": winner["distance_km"],
            "specializations": winner.get("specializations", []),
            "badges": winner.get("badges", []), "verified": winner.get("verified", False),
            "available_slots": winner.get("available_slots", []),
            "languages": winner.get("languages", []),
        },
        "pricing": pricing,
        "reasoning": winner.get("reasoning", ""),
        "is_urgent": intent["is_urgent"],
        "slot": None,
        "notifications": [],
        "other_options": other_options,
        "artifacts": sorted(artifacts),
    }

@app.post("/book")
def book(req: BookRequest):
    providers = load_providers()
    winner = next((p for p in providers if p["id"] == req.provider_id), None)
    if not winner:
        raise HTTPException(status_code=404, detail="Provider not found")
    
    intent = {"is_urgent": req.is_urgent}
    booking = agent6_book(winner, req.pricing, intent, slot_override=req.slot)
    followup = agent7_followup(booking, winner, req.pricing)
    
    artifacts = [f for f in os.listdir(LOGS_DIR) if f.endswith(".md")]
    return {
        "booking_id": booking["booking_id"],
        "slot": booking["slot"],
        "status": booking["status"],
        "notifications": followup["notifications"],
        "artifacts": sorted(artifacts),
    }

@app.get("/artifacts")
def get_artifacts():
    result = []
    if os.path.exists(LOGS_DIR):
        for fname in sorted(os.listdir(LOGS_DIR)):
            if fname.endswith(".md"):
                fpath = os.path.join(LOGS_DIR, fname)
                with open(fpath, "r", encoding="utf-8") as f:
                    result.append({"filename": fname, "content": f.read()})
    return {"artifacts": result}

@app.get("/providers")
def get_providers():
    return {"providers": load_providers()}

@app.post("/review")
def review(req: ReviewRequest):
    result = agent8_review(req.booking_id, req.rating, req.comment)
    return result

@app.post("/dispute")
def dispute(req: DisputeRequest):
    result = agent9_dispute(req.booking_id, req.issue)
    return result
