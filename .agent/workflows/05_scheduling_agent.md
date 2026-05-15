# scheduling-intelligence

**Description:** Books the slot, prevents double-booking, handles conflicts, and manages waitlists.

## Steps

1. Check if the requested time slot in available_slots is still open.
2. If YES: mark it as "booked" in mock_providers.json. Generate booking ID.
3. If NO (slot taken by another user):
   - Check if next 3 available slots work within ±2 hours of requested time
   - Suggest alternates to user
   - If all slots full, add user to a waitlist in waitlist.json
4. Add 30-minute travel buffer around each booking.
5. If provider cancels: automatically find the next-ranked provider from ranking_log.md and re-book.
6. Update bookings.csv with: booking_id, user, provider, service, time, status
7. Create booking_receipt.json artifact with all booking details.
8. Create scheduling_log.md artifact showing the decision trail.
