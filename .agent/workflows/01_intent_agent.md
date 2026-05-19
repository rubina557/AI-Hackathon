name: "intent-understanding"
description: "Parses multilingual input into structured JSON"

Steps:
1. Read user_input variable
2. Use Gemini to parse. Handle all input types:
   - Pure Urdu: "AC بالکل کام نہیں کر رہا"
   - Roman Urdu: "kal subah AC waala chahiye G-13 mein"
   - English: "I need an AC technician tomorrow morning"
   - Mixed: "urgent AC repair chahiye abhi"
   - Misspelled: "electrcian G13 morrning"
3. Extract this exact JSON:
   {
     "service": "AC Technician",
     "location_text": "G-13",
     "location_coords": {"lat": 25.39, "lng": 68.35},
     "time_requested": "tomorrow morning",
     "time_parsed": "2025-05-16 09:00",
     "is_urgent": false,
     "job_complexity": "intermediate",
     "budget_sensitive": true,
     "detected_language": "Roman Urdu",
     "confidence_score": 0.92,
     "needs_clarification": false,
     "clarification_question": ""
   }
4. is_urgent=true if input contains: abhi, urgent, jaldi, ابھی, فوری
5. job_complexity: basic/intermediate/complex based on issue described
6. If confidence < 0.75: set needs_clarification=true,
   write clarification_question in SAME language as input
7. Create artifact: logs/intent_log.md showing:
   - Original input
   - Detected language
   - Extracted JSON
   - Confidence score with explanation
   - Timestamp
