# followup-reminders

**Description:** Schedules and sends all post-booking communications.

## Steps

1. Read booking details from booking_receipt.json.
2. Schedule these simulated notifications:
   - Confirmation: immediately → "Booking confirmed! Ali (AC Tech) at 10 AM, ID: BK-1042"
   - Reminder T-1hr: 1 hour before booking → "Your technician arrives in 1 hour"
   - En-route: when provider starts travel → "Ali is on the way! ETA: 20 min"
   - Completion: after service → "How was your service? Rate Ali."
3. Log all scheduled notifications with timestamps.
4. Create followup_log.md artifact with the full notification timeline.
