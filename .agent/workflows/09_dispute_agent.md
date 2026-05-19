name: "dispute-handler"
description: "Classifies and resolves disputes automatically"

Steps:
1. Classify dispute type:
   - no_show: provider did not arrive
   - quality_complaint: work was poor
   - price_dispute: charged more than quoted
   - overrun: took much longer than estimated
   - cancellation: user or provider cancelled
2. IMPORTANT: Notify user BEFORE any rebooking action is taken
3. Auto-resolve per type:
   - no_show: full refund + provider risk_score +0.3 + reschedule offer
   - price_dispute: compare booking_receipt.json with claimed amount
     If overcharged: refund difference + provider warning
   - quality_complaint: partial refund (30%) + note on profile
   - cancellation (>24hr): no fee. (<24hr): 10% cancellation fee
   - overrun: calculate extra charge, get user approval first
4. If cannot resolve: escalate to admin dashboard
5. Update provider risk_score in Firestore
6. Create artifact: logs/dispute_log.md showing:
   - Dispute type and evidence
   - Decision logic step by step
   - Resolution taken
   - Risk score change
   - Timestamp
