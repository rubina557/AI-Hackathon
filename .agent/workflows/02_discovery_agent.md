name: "provider-discovery"
description: "Finds matching providers from Firestore/mock data"

Steps:
1. Read intent JSON from Agent 1
2. Filter mock_providers.json where category matches service
3. Calculate Haversine distance from user coordinates
4. Filter to providers within 15km AND available in requested time
5. If zero found: expand to 25km
6. If still zero: set no_provider_found=true, suggest next morning slot
7. Return max 10 candidate providers with distances
8. Create artifact: logs/discovery_log.md showing:
   - Search criteria used
   - All candidates found with distances
   - Fallback logic triggered (if any)
   - Timestamp
