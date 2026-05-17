import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'thinking_screen.dart';

const double _hyderLat = 25.3960;
const double _hyderLng = 68.3578;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final MapController _mapCtrl = MapController();

  final List<Map<String, String>> _chips = [
    {'label': 'AC Repair',    'query': 'Mujhe AC technician chahiye'},
    {'label': 'Plumber',      'query': 'Mujhe plumber chahiye'},
    {'label': 'Electrician',  'query': 'Mujhe electrician chahiye'},
    {'label': 'Tutor',        'query': 'Mujhe tutor chahiye'},
    {'label': 'Mechanic',     'query': 'Mujhe mechanic chahiye'},
    {'label': 'Beautician',   'query': 'Mujhe beautician chahiye'},
    {'label': 'Carpenter',    'query': 'Mujhe carpenter chahiye'},
    {'label': 'Painter',      'query': 'Mujhe painter chahiye'},
  ];

  void _submit(String message) {
    if (message.trim().isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ThinkingScreen(message: message.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // MAP
          FlutterMap(
            mapController: _mapCtrl,
            options: const MapOptions(
              initialCenter: LatLng(_hyderLat, _hyderLng),
              initialZoom: 13.5,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.hirein.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: const LatLng(_hyderLat, _hyderLng),
                    width: 48,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A237E),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                      ),
                      child: const Icon(Icons.my_location, color: Colors.white, size: 22),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // TOP BAR
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A237E),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt, color: Color(0xFFFFD700), size: 20),
                        const SizedBox(width: 6),
                        Text('HireIn',
                            style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 18)),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Logs button
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/logs'),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                      ),
                      child: const Icon(Icons.analytics_outlined,
                          color: Color(0xFF1A237E), size: 22),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // BOTTOM PANEL
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -4))],
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 36, height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('What do you need fixed today?',
                      style: GoogleFonts.outfit(
                          fontSize: 18, fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A237E))),
                  Text('آج کیا ٹھیک کروانا ہے؟',
                      style: GoogleFonts.outfit(
                          fontSize: 13, color: Colors.grey.shade500)),
                  const SizedBox(height: 14),
                  // Search bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ctrl,
                          onSubmitted: _submit,
                          style: GoogleFonts.outfit(fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'e.g. "Mujhe AC technician chahiye Hyder Chowk pe"',
                            hintStyle: GoogleFonts.outfit(
                                fontSize: 13, color: Colors.grey.shade400),
                            filled: true,
                            fillColor: const Color(0xFFF5F6FA),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.search,
                                color: Color(0xFF1A237E), size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => _submit(_ctrl.text),
                        child: Container(
                          width: 52, height: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.send_rounded,
                              color: Color(0xFF1A237E), size: 22),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  // Service chips
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _chips.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        final chip = _chips[i];
                        return GestureDetector(
                          onTap: () {
                            _ctrl.text = chip['query']!;
                            _submit(chip['query']!);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A237E).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: const Color(0xFF1A237E).withOpacity(0.2)),
                            ),
                            child: Text(chip['label']!,
                                style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1A237E))),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
