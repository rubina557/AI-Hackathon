# Agent 4: Financial Estimation & Travel Fee Router
- Compute baseline travel expenses for all candidates: `Travel Fee = 100 PKR + (distance_km * 25 PKR)`.
- If `urgency_flag == "Urgent"`, apply a 1.35x surcharge and populate `eta_minutes`.
- If `urgency_flag == "Scheduled"`, leave fee multiplier at 1.0x and explicitly clear the `eta_minutes` state property to `Null` to ensure the frontend code omits the arrival time block.
