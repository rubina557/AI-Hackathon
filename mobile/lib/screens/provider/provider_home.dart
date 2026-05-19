import 'package:flutter/material.dart';
import '../customer/profile_screen.dart';
import 'earnings_screen.dart';

class ProviderHome extends StatefulWidget {
  const ProviderHome({super.key});

  @override
  State<ProviderHome> createState() => _ProviderHomeState();
}

class _ProviderHomeState extends State<ProviderHome> {
  int _currentIndex = 0;
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeTab(),
      const EarningsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      appBar: AppBar(
        title: const Text('Provider Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          Row(
            children: [
              Text(_isOnline ? 'Online' : 'Offline', style: TextStyle(color: _isOnline ? const Color(0xFF00A884) : Colors.grey)),
              Switch(
                value: _isOnline,
                activeColor: const Color(0xFF00A884),
                onChanged: (val) => setState(() => _isOnline = val),
              ),
            ],
          )
        ],
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF202C33),
        selectedItemColor: const Color(0xFF00A884),
        unselectedItemColor: const Color(0xFF8696A0),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.handyman), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildStatCard(),
        const SizedBox(height: 24),
        const Text('ACTIVE JOBS', style: TextStyle(color: Color(0xFF8696A0), fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        const SizedBox(height: 12),
        _buildJobCard(
          customerName: 'Ahmed Raza',
          service: 'AC Repair (Inverter)',
          time: 'Today, 02:00 PM',
          location: 'Latifabad, Unit 7',
          status: 'Confirmed',
        ),
      ],
    );
  }

  Widget _buildStatCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF202C33),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF00A884).withOpacity(0.5)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text('3', style: TextStyle(color: Color(0xFFE9EDEF), fontSize: 24, fontWeight: FontWeight.bold)),
              Text('Today\'s Jobs', style: TextStyle(color: Color(0xFF8696A0))),
            ],
          ),
          Column(
            children: [
              Text('PKR 4,200', style: TextStyle(color: Color(0xFF00A884), fontSize: 24, fontWeight: FontWeight.bold)),
              Text('Earned Today', style: TextStyle(color: Color(0xFF8696A0))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildJobCard({required String customerName, required String service, required String time, required String location, required String status}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(service, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFE9EDEF))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFF00A884).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: Text(status, style: const TextStyle(color: Color(0xFF00A884), fontSize: 12, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 12),
            Row(children: [const Icon(Icons.person, size: 16, color: Color(0xFF8696A0)), const SizedBox(width: 8), Text(customerName, style: const TextStyle(color: Color(0xFFE9EDEF)))]),
            const SizedBox(height: 6),
            Row(children: [const Icon(Icons.access_time, size: 16, color: Color(0xFF8696A0)), const SizedBox(width: 8), Text(time, style: const TextStyle(color: Color(0xFFE9EDEF)))]),
            const SizedBox(height: 6),
            Row(children: [const Icon(Icons.location_on, size: 16, color: Color(0xFF8696A0)), const SizedBox(width: 8), Text(location, style: const TextStyle(color: Color(0xFFE9EDEF)))]),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Update Status'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
