name: "full-booking-pipeline"
description: "Master orchestrator. Controls entire pipeline from user input to booking, follow-up, and dispute handling."

Trigger: receives user_input, user_lat, user_lng, user_id, is_returning_user

Steps:
1. Run @intent-understanding with user_input
   - If needs_clarification=true: STOP, return clarification_question
   - If confidence_score < 0.75: STOP, ask clarification in detected language
2. Run @provider-discovery with intent JSON + user coordinates
   - If no_provider_found=true: expand radius to 25km
   - If still none: return friendly message, suggest different time
3. Run @ranking-engine with discovery results
4. Run @pricing-engine with top ranked provider + intent
5. Run @matchmaker with ranked+priced list
6. Return results to Flutter UI for user to confirm
7. On user confirmation: Run @lock-and-book
   - If slot conflict: return 3 alternate slots to user
8. On booking confirmed:
   a. Run @followup-reminders
   b. Monitor for status updates
9. After job complete: Run @review-badge-manager
10. If dispute raised: Run @dispute-handler
11. If ANY step fails: log in error_log.md, return friendly fallback
    NEVER show raw errors to user
