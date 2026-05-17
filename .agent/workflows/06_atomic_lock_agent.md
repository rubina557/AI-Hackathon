# Agent 6: Atomic Allocation & Schedule Lock

## Objectives
1. Act as a manual execution trigger initialized via the `/book` endpoint when the user explicitly selects a provider card in the UI.
2. Check `booking_slots.json` to perform an atomic write check, ensuring the selected time slot is still open.
3. Lock the database slot, update active availability metrics, issue a unique tracking reference string (`booking_id`), and move the global `booking_status` variable to "Locked".
4. Pass the locked state to Agent 7 (Cron Tracking) for background dispatch monitoring.
