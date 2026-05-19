name: "followup-reminders"
description: "Manages all post-booking notifications"

Steps:
1. Read booking_receipt.json
2. Schedule these notifications via Firebase Cloud Messaging:
   - Immediate: 'Booking confirmed! [Name] at [time]. ID: [BK-XXXX]'
   - T-1hr: 'Your [service] arrives in 1 hour'
   - En-route (when provider marks En Route):
     '[Name] is on the way! ETA: [X] mins'
   - Completion: 'How was your service? Rate [Name]'
3. All notifications in user's preferred language (Urdu/English)
4. SMS fallback for critical notifications
5. Create artifact: logs/followup_log.md with full timeline
