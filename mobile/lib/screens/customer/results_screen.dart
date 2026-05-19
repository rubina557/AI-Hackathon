import 'package:flutter/material.dart';
import 'booking_screen.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      appBar: AppBar(title: const Text('Best Match Found')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('RECOMMENDED', style: TextStyle(color: Color(0xFF8696A0), fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildRecommendedCard(context),
            const SizedBox(height: 32),
            const Text('OTHER OPTIONS', style: TextStyle(color: Color(0xFF8696A0), fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildAlternativeCard(context, 'Bilal Ahmed', '⭐ 4.2', '1,600', '4.5 km'),
            _buildAlternativeCard(context, 'Imran Khan', '⭐ 3.8', '1,450', '6.0 km'),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF202C33),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00A884), width: 2),
        boxShadow: [BoxShadow(color: const Color(0xFF00A884).withOpacity(0.1), blurRadius: 20, spreadRadius: 2)],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFF005C4B),
                child: Text('AH', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ali Hassan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE9EDEF))),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFD700), size: 16),
                      const SizedBox(width: 4),
                      Text('4.8 (145 reviews)', style: TextStyle(color: Colors.grey[400])),
                    ],
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _BadgeChip('Top Rated'),
              _BadgeChip('Expert Level'),
              _BadgeChip('Verified'),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF111B21),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Visit Fee', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                    const Text('PKR 1,850', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00A884))),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Distance & ETA', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                    const Text('3.2 km (~18m)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE9EDEF))),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              iconColor: const Color(0xFF00A884),
              collapsedIconColor: const Color(0xFF8696A0),
              title: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Color(0xFF00A884), size: 18),
                  SizedBox(width: 8),
                  Text('AI Match Reasoning', style: TextStyle(color: Color(0xFF00A884), fontWeight: FontWeight.w600)),
                ],
              ),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF005C4B).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Ali was chosen over closer providers because of his 4.8 rating and expert skill level in inverter AC repair.',
                    style: TextStyle(color: Color(0xFFE9EDEF), height: 1.4),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingScreen(providerName: 'Ali Hassan', fee: 1850)));
              },
              child: const Text('Accept & Book', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAlternativeCard(BuildContext context, String name, String rating, String price, String distance) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.white10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Navigating to BookingScreen with the selected alternative provider
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => BookingScreen(providerName: name, fee: double.parse(price.replaceAll(',', '')))
            )
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF202C33),
                child: Icon(Icons.person, color: Colors.grey[400]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFE9EDEF))),
                    const SizedBox(height: 4),
                    Text('$rating  •  $distance away', style: const TextStyle(color: Color(0xFF8696A0), fontSize: 13)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('PKR $price', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00A884), fontSize: 15)),
                  const SizedBox(height: 4),
                  const Text('Select >', style: TextStyle(color: Color(0xFF8696A0), fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  final String label;
  const _BadgeChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF202C33),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFFE9EDEF))),
    );
  }
}
