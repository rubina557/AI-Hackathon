import 'package:flutter/material.dart';

class AgentLogsScreen extends StatelessWidget {
  const AgentLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF202C33),
          title: const Text('AI Decision Transparency'),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Color(0xFF00A884),
            unselectedLabelColor: Color(0xFF8696A0),
            indicatorColor: Color(0xFF00A884),
            tabs: [
              Tab(text: 'Intent'),
              Tab(text: 'Discovery'),
              Tab(text: 'Ranking'),
              Tab(text: 'Pricing'),
              Tab(text: 'Match'),
              Tab(text: 'Scheduling'),
              Tab(text: 'Follow-up'),
              Tab(text: 'Quality'),
              Tab(text: 'Dispute'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLogViewer(
              '[AGENT 1: Intent & Category Parsing]\n'
              '------------------------------------\n'
              'Timestamp: 2026-05-19T20:35:12Z\n'
              'Input Prompt: "AC repair needed tomorrow"\n\n'
              'Processing Analysis:\n'
              '- Extracted Intent: Service Booking\n'
              '- Primary Category Identified: AC Repair\n'
              '- Temporal Entities Detected: "tomorrow" (Resolved to: 2026-05-20)\n'
              '- Language Classification: English with Roman-Urdu context fallback\n'
              '- Sentiment Analysis: Neutral (0.76)\n\n'
              'Model Confidence Metrics:\n'
              '- Category Matching score: 0.985\n'
              '- Intent Resolution score: 0.952\n'
              '- Overall Parsing Reliability: 0.968\n\n'
              'Recommendation Reasoning: User prompt indicates an active malfunction with AC cooling mechanism. Routing search query to Discovery Agent for HVAC/AC category specialists.'
            ),
            _buildLogViewer(
              '[AGENT 2: Provider Discovery & Availability Filtering]\n'
              '------------------------------------------------------\n'
              'Timestamp: 2026-05-19T20:35:13Z\n'
              'Search Parameter Bounds:\n'
              '- Latitude Target: 25.3960\n'
              '- Longitude Target: 68.3578\n'
              '- Radius: 15.0 km\n'
              '- Match Skill: "AC Repair"\n\n'
              'Discovery Pipeline Execution:\n'
              '- Scanning database: 12 providers found in registry.\n'
              '- Filtering by skill category ("AC Repair")... 5 candidates matched.\n'
              '- Filtering by active geographical bounds (< 15km)... 4 candidates remain.\n'
              '- Enforcing Shift / Availability Check...\n'
              '  * Candidate Ali Hassan: Available (Slots: 09:00 AM, 11:30 AM, 02:00 PM) - PASS\n'
              '  * Candidate Bilal Ahmed: Available (Slots: 10:00 AM, 01:00 PM) - PASS\n'
              '  * Candidate Sajid Mehmood: Available (Slots: 04:00 PM) - PASS\n'
              '  * Candidate Muhammad Rizwan: No remaining slots today - EXCLUDED\n\n'
              'Final Discovery Registry:\n'
              '1. Ali Hassan (HVAC Senior Tech) - 1.2km away\n'
              '2. Bilal Ahmed (AC Technician) - 3.4km away\n'
              '3. Sajid Mehmood (General Maintenance) - 5.8km away'
            ),
            _buildLogViewer(
              '[AGENT 3: Multi-Criteria Scored Ranking & Emergency Prioritization]\n'
              '-------------------------------------------------------------------\n'
              'Timestamp: 2026-05-19T20:35:14Z\n'
              'Urgent Flag Status: FALSE (Normal Mode)\n\n'
              'Ranking Weights Applied (Standard Mode):\n'
              '- Proximity Weight: 20%\n'
              '- Rating Weight: 40%\n'
              '- Skill Match Weight: 30%\n'
              '- Experience Weight: 10%\n\n'
              'Scoring Matrix Evaluation:\n'
              '1. Candidate: Ali Hassan\n'
              '   - Distance: 1.2 km (Score: 98/100)\n'
              '   - Rating: 4.9 stars (Score: 98/100)\n'
              '   - Experience: 8 years (Score: 90/100)\n'
              '   - Weighted Aggregate Score: 96.4 -> RANK #1\n\n'
              '2. Candidate: Bilal Ahmed\n'
              '   - Distance: 3.4 km (Score: 82/100)\n'
              '   - Rating: 4.7 stars (Score: 94/100)\n'
              '   - Experience: 4 years (Score: 80/100)\n'
              '   - Weighted Aggregate Score: 88.0 -> RANK #2\n\n'
              '3. Candidate: Sajid Mehmood\n'
              '   - Distance: 5.8 km (Score: 68/100)\n'
              '   - Rating: 4.2 stars (Score: 84/100)\n'
              '   - Experience: 2 years (Score: 60/100)\n'
              '   - Weighted Aggregate Score: 77.2 -> RANK #3\n\n'
              'Emergency Overrides: Disabled.'
            ),
            _buildLogViewer(
              '[AGENT 4: Dynamic Pricing Orchestrator]\n'
              '---------------------------------------\n'
              'Timestamp: 2026-05-19T20:35:14Z\n'
              'Target Provider: Ali Hassan (AC Repair)\n\n'
              'Base Cost Matrix Calculation:\n'
              '- Standard Base Rate (AC Repair): PKR 1,700\n'
              '- Distance/Travel Surcharge (1.2 km): PKR 100\n'
              '- Platform Admin Service Fee: PKR 50\n\n'
              'Urgency/Peak Surge Pricing Multiplier:\n'
              '- Peak Hours Multiplier: 1.0x (No surge active)\n'
              '- Late Night / Emergency Surcharge: PKR 0\n\n'
              'Final Quote Summary Breakdown:\n'
              '----------------------------------\n'
              '- Base Fee: PKR 1,700\n'
              '- Travel Surcharge: PKR 100\n'
              '- Platform Fee: PKR 50\n'
              '----------------------------------\n'
              'Total Estimated Cost: PKR 1,850'
            ),
            _buildLogViewer(
              '[AGENT 5: Matchmaker Agent Final Decision & Reasoning]\n'
              '------------------------------------------------------\n'
              'Timestamp: 2026-05-19T20:35:15Z\n\n'
              'Final Orchestration Recommendation:\n'
              'Assigning provider: Ali Hassan (ID: P-001)\n\n'
              'Reasoning Rationale:\n'
              '- Ali Hassan ranks #1 on the scoring matrix (Score: 96.4) due to a combination of highly positive customer ratings (4.9 stars) and close proximity (1.2 km) to the user\'s location.\n'
              '- Provider is currently active, within their shift hours, and has multiple matching vacant slots (including 09:00 AM slot).\n'
              '- Quoted base price of PKR 1,700 is within user\'s historical spend tolerances.\n\n'
              'Status: Ready for slot selection and final booking confirmation.'
            ),
            _buildLogViewer(
              '[AGENT 6: Scheduling & Lock Buffer Agent]\n'
              '-----------------------------------------\n'
              'Timestamp: 2026-05-19T20:35:16Z\n'
              'Booking ID Reference: BK-4829\n\n'
              'Transaction Registry Execution:\n'
              '- Validating Provider Availability... Ali Hassan is ACTIVE.\n'
              '- Target Shift Slot: 09:00 AM - 11:30 AM (Reserved)\n'
              '- Enforcing Conflict Verification... PASS (0 conflicts detected).\n'
              '- Applying Temporal Safety Buffers...\n'
              '  * +30 min pre-service travel allowance applied.\n'
              '  * +30 min post-service cleanup buffer applied.\n'
              '- Status Flag Updated: "locked_and_confirmed"\n'
              '- Committing to Booking Registry (bookings.csv)... DONE.'
            ),
            _buildLogViewer(
              '[AGENT 7: Follow-up & Automated Tracking Timeline]\n'
              '--------------------------------------------------\n'
              'Timestamp: 2026-05-19T20:35:16Z\n'
              'Target Booking: BK-4829\n\n'
              'Scheduled Notifications Pipeline:\n'
              '1. Immediate Confirmation:\n'
              '   - SMS: "✅ Booking confirmed! Ali Hassan is arriving at 09:00 AM. Ref: BK-4829" -> SENT\n\n'
              '2. T-1 Hour Reminder:\n'
              '   - Push: "⏰ Reminder: Your technician Ali Hassan arrives in 1 hour." -> QUEUED\n\n'
              '3. Dispatch Tracker (En Route):\n'
              '   - SMS: "🚗 Ali Hassan is en route! ETA: 12 minutes." -> QUEUED\n\n'
              '4. Post-Service Feedback:\n'
              '   - Push: "⭐ How was your service? Rate Ali Hassan." -> QUEUED'
            ),
            _buildLogViewer(
              '[AGENT 8: Quality Assurance & Review Agent]\n'
              '-------------------------------------------\n'
              'Timestamp: 2026-05-19T20:35:17Z\n'
              'Target Booking: BK-4829\n\n'
              'User Ratings Received:\n'
              '- Star Rating: 5.0 / 5.0\n'
              '- Comments: "Excellent work, solved the issue quickly."\n\n'
              'QA Performance Matrix Update:\n'
              '- Provider ID: P-001 (Ali Hassan)\n'
              '- Past Rating Average: 4.88\n'
              '- New Rating Average: 4.90 (Recalculated with weight: 1.0)\n'
              '- Total Review Count: 48 -> 49\n'
              '- Review Recency Factor: Reset to 0 days\n'
              '- Performance Badge Assessment: "Highly Reliable", "Top Rated" maintained.'
            ),
            _buildLogViewer(
              '[AGENT 9: Dispute Resolution & Risk Mitigation Agent]\n'
              '------------------------------------------------------\n'
              'Timestamp: 2026-05-19T20:35:18Z\n'
              'Target Booking: BK-4829\n\n'
              'Risk Profile Evaluation:\n'
              '- Active Dispute Flags: NONE (0)\n'
              '- Historical Refund Rates: 0%\n\n'
              'Auto-Resolution Policy Mapping:\n'
              '- Scenario: Standard Completion\n'
              '- Status: No dispute initiated.\n'
              '- Provider Risk Coefficient: 0.02 (Extremely Low Risk - Clear rating)\n'
              '- Action: Escalate to human operator: FALSE.\n'
              '- Auto-Release Funds Status: APPROVED (100% payout released).'
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogViewer(String logContent) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Text(
          logContent,
          style: const TextStyle(
            fontFamily: 'Courier',
            color: Colors.greenAccent,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
