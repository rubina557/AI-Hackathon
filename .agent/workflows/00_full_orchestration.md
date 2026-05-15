# full-booking-pipeline

**Description:** Master orchestrator. Runs all agents in sequence from user input to booking confirmation and follow-up.

Trigger this workflow with a `user_input` variable.

## Steps

1. Run @intent-understanding. Wait for JSON output.
   - If needs_clarification = true: STOP and return clarification_question to user.
   - If confidence_score < 0.75: STOP and ask for clarification.
2. Pass the JSON to @provider-discovery.
   - If no_provider_available = true: return friendly message to user.
3. Pass discovery results to @provider-ranking.
4. Pass top-ranked provider to @dynamic-pricing.
5. Pass ranked provider and time intent to @scheduling-intelligence.
   - If slot conflict: return alternate time suggestions to user.
6. If booking confirmed:
   a. Run @service-quality-loop
   b. Run @followup-reminders
   c. Check if any flags exist → run @dispute-escalation if needed
7. Generate a final user_response.md artifact.
8. If ANY step fails: log the error in error_log.md and return a user-friendly fallback message.
