import 'package:flutter/material.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock booking data
    final List<Map<String, dynamic>> mockBookings = [
      {
        'id': 'BK-4829',
        'provider': 'Ali Hassan',
        'service': 'Electrician',
        'date': '2026-05-18 10:30 AM',
        'amount': 'PKR 1,850',
        'status': 'Completed',
        'statusColor': Colors.green,
      },
      {
        'id': 'BK-1082',
        'provider': 'Sajid Mehmood',
        'service': 'Plumber',
        'date': '2026-05-15 02:00 PM',
        'amount': 'PKR 1,500',
        'status': 'Completed',
        'statusColor': Colors.green,
      },
      {
        'id': 'BK-9912',
        'provider': 'Muhammad Rizwan',
        'service': 'AC Repair',
        'date': '2026-05-10 11:00 AM',
        'amount': 'PKR 2,400',
        'status': 'Cancelled',
        'statusColor': Colors.red,
      }
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      appBar: AppBar(
        title: const Text('Booking History'),
        backgroundColor: const Color(0xFF202C33),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: mockBookings.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final b = mockBookings[index];
          return Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF202C33),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      b['id'],
                      style: const TextStyle(
                        color: Color(0xFF00A884),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: (b['statusColor'] as Color).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        b['status'],
                        style: TextStyle(
                          color: b['statusColor'],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  b['service'],
                  style: const TextStyle(
                    color: Color(0xFFE9EDEF),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.person, color: Color(0xFF8696A0), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      b['provider'],
                      style: const TextStyle(color: Color(0xFF8696A0), fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF8696A0), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      b['date'],
                      style: const TextStyle(color: Color(0xFF8696A0), fontSize: 14),
                    ),
                  ],
                ),
                const Divider(color: Colors.white10, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Price',
                      style: TextStyle(color: Color(0xFF8696A0), fontSize: 14),
                    ),
                    Text(
                      b['amount'],
                      style: const TextStyle(
                        color: Color(0xFFE9EDEF),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
