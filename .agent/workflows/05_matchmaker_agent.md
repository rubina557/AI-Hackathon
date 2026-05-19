name: "matchmaker"
description: "Selects winner, writes reasoning, assigns badges"

Steps:
1. Select final RECOMMENDED provider (highest ranked + priced)
2. Select 2-3 ALTERNATIVES from ranked list
3. Write reasoning_summary (2-3 lines) explaining:
   - Why this provider was chosen
   - What makes them better than alternatives
   - Key differentiating factor
   Example: 'Ali was chosen over closer Bilal because Ali has
   4.8 rating vs 4.1, specializes in inverter AC repair, and
   has 0% cancellation rate in the last 30 days.'
4. Assign smart badges dynamically:
   POSITIVE (shown on card):
   - Top Rated: rating >= 4.7 AND review_count >= 20
   - Expert Level: skill_level = expert
   - Verified: cnic_verified = true
   - Affordable: price in lowest 25% of shortlist
   - On Time: on_time_score >= 0.90
   - Fastest ETA: closest provider (urgent only)
   NEGATIVE FLAGS (affect ranking, NOT shown as badges):
   - Expensive: price in top 25% of shortlist
   - Late: on_time_score < 0.70
   - Unprofessional: negative review badge chips from customers
5. Create artifact: logs/matchmaker_log.md
