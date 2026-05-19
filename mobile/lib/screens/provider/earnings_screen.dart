import 'package:flutter/material.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF005C4B),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
            children: [
              Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 16)),
              SizedBox(height: 8),
              Text('PKR 12,450', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: null, // Disabled in mock
                child: Text('Withdraw to EasyPaisa'),
              )
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text('RECENT TRANSACTIONS', style: TextStyle(color: Color(0xFF8696A0), fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildTransaction('AC Repair (Ahmed)', 'PKR 1,850', 'Today, 2:00 PM'),
        _buildTransaction('Plumbing (Sana)', 'PKR 1,200', 'Yesterday, 11:00 AM'),
        _buildTransaction('Withdrawal', '-PKR 5,000', 'May 14, 2025', isDebit: true),
      ],
    );
  }

  Widget _buildTransaction(String title, String amount, String date, {bool isDebit = false}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: const Color(0xFF202C33),
      child: ListTile(
        leading: Icon(isDebit ? Icons.account_balance_wallet : Icons.check_circle, color: isDebit ? Colors.white54 : const Color(0xFF00A884)),
        title: Text(title, style: const TextStyle(color: Color(0xFFE9EDEF))),
        subtitle: Text(date, style: const TextStyle(color: Color(0xFF8696A0))),
        trailing: Text(
          amount,
          style: TextStyle(
            color: isDebit ? Colors.white54 : const Color(0xFF00A884),
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
        ),
      ),
    );
  }
}
