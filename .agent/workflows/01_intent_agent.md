# Intent Agent Workflow

This agent processes natural language user queries in Roman Urdu, Urdu, or English and extracts structured intent for service booking.

## Input
A text phrase. (e.g., "mujhe kl subah bijli wala chahiye Qasimabad mein")

## Processing Rules
1. Extract `service_type`:
   - Map slang like 'bijli wala' to `ELECTRICIAN`
   - Map 'pani' or 'plumber' to `PLUMBER`
   - Map 'ac' or 'thanda' to `AC TECHNICIAN`
2. Extract `location`:
   - Identify city areas like 'Qasimabad'.
3. Extract `time`:
   - Translate time phrases to English. E.g., 'kl subah' mapped to `Tomorrow morning`, 'abhi' mapped to `Immediately`.

## Output
A JSON representation of the intent and an `intent_log.md` artifact detailing the reasoning for extracting these fields.
