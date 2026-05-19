import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'thinking_screen.dart';
import 'agent_logs_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const _CustomerHomeTab(),
    const AgentLogsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF202C33),
        selectedItemColor: const Color(0xFF00A884),
        unselectedItemColor: const Color(0xFF8696A0),
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: 'AI Logs'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _CustomerHomeTab extends StatelessWidget {
  const _CustomerHomeTab();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: const LatLng(25.3960, 68.3578),
            initialZoom: 13.0,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.hirein.app',
            ),
          ],
        ),
        
        Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF202C33).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFF00A884), size: 18),
                    SizedBox(width: 8),
                    Text('Hyderabad, Sindh', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE9EDEF))),
                  ],
                ),
              ),
              CircleAvatar(
                backgroundColor: const Color(0xFF00A884),
                child: IconButton(
                  icon: const Icon(Icons.person, color: Color(0xFF111B21)),
                  onPressed: () {
                    // Access profile via Nav, or directly push
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                  },
                ),
              )
            ],
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(24.0),
            decoration: const BoxDecoration(
              color: Color(0xFF111B21),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, -5))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Need a fix? / مدد درکار ہے؟', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFFE9EDEF))),
                const SizedBox(height: 8),
                const Text('Describe your problem or select a category below\nاپنا مسئلہ تفصیل سے لکھیں یا نیچے دی گئی کیٹیگری منتخب کریں۔', style: TextStyle(color: Color(0xFF8696A0), fontSize: 13, height: 1.4)),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'آج کیا ٹھیک کروانا ہے؟...',
                    hintStyle: const TextStyle(color: Color(0xFF8696A0)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF00A884)),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ThinkingScreen()));
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFF202C33),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Color(0xFFE9EDEF)),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildChip('AC Repair', Icons.ac_unit),
                      _buildChip('Plumber', Icons.plumbing),
                      _buildChip('Electrician', Icons.electrical_services),
                      _buildChip('Mechanic', Icons.build),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildChip(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF202C33),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF00A884), size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Color(0xFFE9EDEF))),
          ],
        ),
      ),
    );
  }
}
