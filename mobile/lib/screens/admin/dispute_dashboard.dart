import 'package:flutter/material.dart';

class DisputeDashboard extends StatelessWidget {
  const DisputeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('ACTION REQUIRED', style: TextStyle(color: Color(0xFF8696A0), fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildDisputeCard(
          id: 'DSP-092',
          type: 'Overcharge Complaint',
          customer: 'Zainab (BK-1024)',
          provider: 'Ali Hassan',
          aiRecommendation: 'Refund PKR 1300. Provider charged 3500 instead of 2200.',
        ),
        _buildDisputeCard(
          id: 'DSP-093',
          type: 'No Show',
          customer: 'Usman (BK-2051)',
          provider: 'Imran Khan',
          aiRecommendation: 'Full refund + Penalty. Provider GPS shows no movement.',
        ),
      ],
    );
  }

  Widget _buildDisputeCard({required String id, required String type, required String customer, required String provider, required String aiRecommendation}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: const Color(0xFF202C33),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFF15C6D), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(type, style: const TextStyle(color: Color(0xFFE9EDEF), fontSize: 18, fontWeight: FontWeight.bold)),
                Text(id, style: const TextStyle(color: Color(0xFF8696A0))),
              ],
            ),
            const SizedBox(height: 12),
            Text('Customer: $customer', style: const TextStyle(color: Color(0xFF8696A0))),
            Text('Provider: $provider', style: const TextStyle(color: Color(0xFF8696A0))),
            const Divider(color: Colors.white24, height: 24),
            Row(
              children: [
                const Icon(Icons.psychology, color: Color(0xFF00A884), size: 20),
                const SizedBox(width: 8),
                const Text('AI Resolution', style: TextStyle(color: Color(0xFF00A884), fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(aiRecommendation, style: const TextStyle(color: Color(0xFFE9EDEF))),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A884)),
                    onPressed: () {},
                    child: const Text('Approve AI', style: TextStyle(color: Color(0xFF111B21))),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFE9EDEF), side: const BorderSide(color: Colors.white24)),
                    onPressed: () {},
                    child: const Text('Manual Override'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
