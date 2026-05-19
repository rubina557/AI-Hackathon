name: "ranking-engine"
description: "Scores and ranks all candidate providers on 10 factors"

Steps:
1. For each candidate provider, calculate score using these weights:
   - Star Rating: 20% (normalized 1-5 → 0-100)
   - Distance/Travel Time: 15% (closer = higher score)
   - Skill Specialization Match: 15% (exact match = 100, partial = 50)
   - On-Time Score: 15% (direct percentage)
   - Shift Availability: 10% (has slot in requested window = 100)
   - Review Recency: 10% (reviewed in last 7 days = 100, 30 days = 60)
   - Budget Match: 5% (if budget_sensitive, cheaper providers score higher)
   - Cancellation Rate: 5% (lower = higher score)
   - Capacity Available: 3% (not at max jobs = higher score)
   - Risk Score: 2% (lower risk = higher score)
2. Calculate total weighted score for each provider
3. Sort descending by total score
4. IMPORTANT: A closer provider does NOT always win.
   Higher reliability + specialization match can beat distance.
5. Create artifact: logs/ranking_log.md showing:
   - Full scoring table for ALL providers across ALL 10 factors
   - Final ranked list
   - Rationale for top 3 positions
   - Why Provider A beats Provider B (even if B is closer)
   - Timestamp
