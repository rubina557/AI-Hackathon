name: "pricing-engine"
description: "Calculates transparent itemized price quote"

Pricing Formula:
  base_fee = provider base_rate_pkr (100-300 PKR per category)
  travel_fee = distance_km × provider travel_rate_pkr_per_km
  urgent_surcharge = 150 PKR flat if is_urgent=true, else 0
  complexity_adjustment: basic=0%, intermediate=+15%, complex=+30%
  subtotal = base_fee + travel_fee + urgent_surcharge + complexity
  platform_fee = 10% × subtotal
  total = subtotal + platform_fee
  provider_earnings = subtotal (platform keeps platform_fee)
  loyalty_discount = -5% if user has 2+ past bookings
  demand_surge = +10% if time is 9am-12pm or 5pm-8pm

Steps:
1. Calculate for top ranked provider
2. If budget_sensitive=true: also calculate for cheapest provider
3. Show full line-item breakdown
4. Show what provider earns vs platform cut
5. Create artifact: logs/pricing_log.md showing:
   - Every line item with calculation
   - Provider earnings
   - Budget alternative if applicable
   - Fairness note
   - Timestamp
