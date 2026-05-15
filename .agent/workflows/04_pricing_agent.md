# dynamic-pricing

**Description:** Generates a transparent, itemized price quote that is fair to both the user and the provider.

## Steps

1. Take the top-ranked provider and the intent JSON.
2. Calculate quote using these components:
   - base_fee = provider's base_rate_pkr
   - distance_fee = distance_km × 50 PKR/km
   - urgency_adjustment: urgent = +20%, normal = 0%, flexible = -10%
   - complexity_adjustment: basic = 0%, intermediate = +15%, complex = +30%
   - demand_surge: peak hours (9am-12pm, 5pm-8pm) = +10%
   - loyalty_discount: 0% (new user), 5% (returning)
   - TOTAL = sum of all components
   - budget_alternative: if user is price-sensitive, show cheapest available provider
3. Show complete line-item breakdown.
4. Show what the provider earns (after platform cut of 10%).
5. Create pricing_log.md artifact with:
   - Full itemized quote
   - Provider earnings
   - Budget-friendly alternative if applicable
   - Fairness note for both parties
