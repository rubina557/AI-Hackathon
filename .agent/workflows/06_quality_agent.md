# service-quality-loop

**Description:** Simulates the full post-booking service lifecycle.

## Steps

1. Simulate provider en-route update: "Ali is on his way. ETA: 25 minutes."
2. Simulate service completion checklist:
   - Job completed: yes/no
   - Photo evidence: [placeholder: "photo_001.jpg"]
   - Time taken: 45 minutes
3. Collect simulated customer feedback: rating (1-5) + text comment.
4. Update provider's rating in mock_providers.json using weighted average:
   new_rating = (old_rating × review_count + new_rating) / (review_count + 1)
5. Update review_recency_days to 0.
6. Create quality_log.md artifact showing the full service timeline and how the new rating affects future matching.
