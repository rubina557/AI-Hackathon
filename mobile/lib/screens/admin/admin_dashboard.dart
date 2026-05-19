import 'package:flutter/material.dart';
import '../customer/profile_screen.dart';
import 'dispute_dashboard.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const _AdminMetricsTab(),
      const Center(child: Text('Approval Queue', style: TextStyle(color: Colors.white))),
      const DisputeDashboard(),
      const ProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      appBar: AppBar(
        title: const Text('Admin Console'),
        backgroundColor: const Color(0xFF202C33),
        automaticallyImplyLeading: false,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF202C33),
        selectedItemColor: const Color(0xFFF15C6D), // Admin uses Red for highlight
        unselectedItemColor: const Color(0xFF8696A0),
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Metrics'),
          BottomNavigationBarItem(icon: Icon(Icons.verified_user), label: 'Approvals'),
          BottomNavigationBarItem(icon: Icon(Icons.gavel), label: 'Disputes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _AdminMetricsTab extends StatelessWidget {
  const _AdminMetricsTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('PLATFORM OVERVIEW', style: TextStyle(color: Color(0xFF8696A0), fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildMetricCard('Total Revenue', 'PKR 145,000', Icons.attach_money)),
            const SizedBox(width: 12),
            Expanded(child: _buildMetricCard('Active Jobs', '42', Icons.work)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildMetricCard('Pending Approvals', '7', Icons.hourglass_empty, color: const Color(0xFFF15C6D))),
            const SizedBox(width: 12),
            Expanded(child: _buildMetricCard('Open Disputes', '2', Icons.warning, color: const Color(0xFFF15C6D))),
          ],
        ),
        const SizedBox(height: 32),
        const Text('RECENT ACTIVITY', style: TextStyle(color: Color(0xFF8696A0), fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildActivityTile('Booking Completed', 'Ali Hassan finished AC Repair', '2 mins ago'),
        _buildActivityTile('Dispute Raised', 'Overcharge complaint on BK-1024', '15 mins ago', isAlert: true),
        _buildActivityTile('New Provider', 'Bilal applied as Plumber', '1 hr ago'),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF202C33),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color ?? const Color(0xFFE9EDEF), size: 24),
          const SizedBox(height: 12),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color ?? const Color(0xFFE9EDEF))),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Color(0xFF8696A0), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildActivityTile(String title, String subtitle, String time, {bool isAlert = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: isAlert ? const Color(0xFFF15C6D).withOpacity(0.2) : const Color(0xFF00A884).withOpacity(0.2),
        child: Icon(isAlert ? Icons.warning : Icons.check, color: isAlert ? const Color(0xFFF15C6D) : const Color(0xFF00A884)),
      ),
      title: Text(title, style: const TextStyle(color: Color(0xFFE9EDEF), fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF8696A0))),
      trailing: Text(time, style: const TextStyle(color: Color(0xFF8696A0), fontSize: 12)),
    );
  }
}
