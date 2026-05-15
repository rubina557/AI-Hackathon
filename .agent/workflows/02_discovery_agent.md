# Discovery Agent Workflow

This agent takes the extracted intent and filters the available service providers list to find valid candidates.

## Input
- `intent`: JSON from the Intent Agent.
- `user_lat`, `user_lng`: Location coordinates.

## Processing Rules
1. **Filter by Service Category**: Only keep providers whose `category` matches `intent.service_type`.
2. **Calculate Distance**: Use the Haversine formula to compute distance from user location to provider location.
3. **Filter by Distance**: Drop any provider outside a 15km radius.

## Output
A JSON list of candidate providers with distance attached, and a `discovery_log.md` artifact detailing which providers were included and dropped.
