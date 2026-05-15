# Intent Extraction Log

**Input Phrase:** "mujhe kal subah electrician chahiye G-11 mein"

## Extraction Reasoning
1. **Service Category:** 'electrician' maps directly to `ELECTRICIAN`.
2. **Location:** 'G-11' identified as the location text. Mapped to coords (Lat: 25.4050, Lng: 68.3550).
3. **Time Preference:** 'kal subah' translated to `Tomorrow morning`.
4. **Urgency:** Implicitly `normal` as no immediate urgency keywords (like "abhi") were used.

## Final Output JSON
```json
{
  "service_category": "ELECTRICIAN",
  "location": {
    "text": "G-11",
    "lat": 25.4050,
    "lng": 68.3550
  },
  "time_preference": {
    "date": "Tomorrow",
    "time_of_day": "Morning"
  },
  "urgency": "normal",
  "confidence_score": 0.95,
  "needs_clarification": false
}
```
