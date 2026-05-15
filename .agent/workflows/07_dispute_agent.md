# dispute-escalation

**Description:** Handles no-shows, complaints, price disputes, and refund requests.

## Steps

1. Classify the dispute type:
   - no_show: provider did not arrive
   - quality_complaint: work was poor
   - price_dispute: charged more than quoted
   - overrun: took much longer than estimated
   - cancellation: user or provider cancelled
2. For each type, follow this logic:
   - no_show: auto-refund + add provider to watchlist + reschedule
   - quality_complaint: flag for review + partial refund + note on profile
   - price_dispute: compare booking_receipt.json with claimed charge + decide
   - overrun: calculate additional charge based on time + approval required
   - cancellation: check who cancelled, apply policy (24hr free, <24hr = fee)
3. If dispute cannot be resolved automatically: escalate to "human review" and log the escalation reason.
4. Update provider risk_score accordingly.
5. Create dispute_log.md artifact showing the dispute, decision logic, and resolution taken.
