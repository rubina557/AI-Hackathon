name: "review-badge-manager"
description: "Processes rating + badge chips, updates provider profile"

Steps:
1. Receive: rating (1-5), badge_chips[], optional comment, booking_id
2. Badge chips from customer (positive): Affordable, On Time, Professional
3. Badge chips from customer (negative): Expensive, Late, Unprofessional,
   Messy Work
4. Update provider rating (weighted average):
   new_rating = (old_rating × review_count + new_rating) / (review_count + 1)
5. Recalculate and reassign ALL smart badges based on updated metrics
6. If 3+ negative chips in last 10 reviews: flag for admin review
7. Set review_recency_days = 0
8. Update Firestore provider document
9. Create artifact: logs/review_log.md showing:
   - Old vs new rating
   - Badge changes
   - Impact on future ranking
   - Timestamp
