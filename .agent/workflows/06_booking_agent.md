name: "lock-and-book"
description: "Locks slot, creates booking, triggers payment"

Steps:
1. Check if requested slot is still available (race condition check)
2. If YES: lock slot, generate booking_id = BK- + 4 random digits
3. If NO (double booking conflict):
   - Find next 3 available slots within ±2 hours
   - Return to user for selection
   - Log double_booking_conflict in scheduling_log.md
4. Add 30-minute travel buffer before and after slot
5. If all slots full: add to waitlist.json
6. Create booking record in Firestore:
   { booking_id, user_id, provider_id, service, location,
     slot, status: 'booked', pricing, created_at }
7. Trigger Stripe sandbox payment (mock)
8. Only confirm booking AFTER payment success
9. Create artifacts:
   - logs/booking_log.md (decision trail)
   - booking_receipt.json (full booking details)
