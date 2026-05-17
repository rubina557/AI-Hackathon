# Agent 6: Manual Booking Execution
- Stand by for explicit callback instructions containing `selected_provider_id` and `selected_time_slot`.
- Execute an atomic verification check on `booking_slots.json`. If the spot is available, change `booking_status` to "Confirmed", build a unique tracking token ID, and alert the tracking module.
