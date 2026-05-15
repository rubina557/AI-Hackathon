# Ranking Agent Workflow

This agent takes the filtered candidates and ranks them to select the single best provider for the job.

## Input
- `candidates`: JSON list of filtered candidate providers from the Discovery Agent.

## Processing Rules
1. **Score Calculation**: Evaluate each candidate using the exact formula:
   `Score = ( (1 / (distance + 1)) * 0.4 ) + ( (rating / 5) * 0.4 ) + ( availability_score * 0.2 )`
   *(where `availability_score` is capped at 1.0 if they have slots, 0.0 if they don't)*
2. **Selection**: Pick the candidate with the highest total score.

## Output
The selected best provider JSON, and a `ranking_log.md` artifact detailing the math for each candidate and the final selection reasoning.
