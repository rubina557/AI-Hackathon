import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../services/api_service.dart';

class ActiveJobScreen extends StatefulWidget {
  final String bookingId;
  final String providerName;
  final String slot;

  const ActiveJobScreen({
    super.key,
    required this.bookingId,
    required this.providerName,
    required this.slot,
  });

  @override
  State<ActiveJobScreen> createState() => _ActiveJobScreenState();
}

class _ActiveJobScreenState extends State<ActiveJobScreen> {
  bool _jobComplete = false;
  int _status = 0; // 0: Confirmed, 1: En Route, 2: Arrived
  double _rating = 0;
  final TextEditingController _commentCtrl = TextEditingController();
  bool _submitting = false;
  bool _reviewDone = false;
  int _countdown = 1800; // 30 min in seconds
  Timer? _countdownTimer;

  // Mock locations for tracking
  final LatLng _userLocation = const LatLng(25.3960, 68.3578);
  late LatLng _providerLocation;

  @override
  void initState() {
    super.initState();
    // Start provider a bit further away
    _providerLocation = const LatLng(25.4050, 68.3650);

    // Initial delay before moving to "En Route"
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _status = 1);
        _showNotification('En Route', '${widget.providerName} is on the way!');
      }
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
          // Simulate movement
          if (_status == 1) {
            _providerLocation = LatLng(
              _providerLocation.latitude - (_providerLocation.latitude - _userLocation.latitude) * 0.05,
              _providerLocation.longitude - (_providerLocation.longitude - _userLocation.longitude) * 0.05,
            );
          }
          if (_countdown == 300 && _status == 1) {
            _status = 2; // Arriving soon
            _showNotification('Arriving Soon', '${widget.providerName} is almost there!');
          }
        });
      } else {
        t.cancel();
        setState(() => _jobComplete = true);
      }
    });
  }

  void _showNotification(String title, String body) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(body, style: GoogleFonts.outfit()),
          ],
        ),
        backgroundColor: const Color(0xFF1A237E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      )
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _commentCtrl.dispose();
    super.dispose();
  }

  String get _countdownStr {
    final m = _countdown ~/ 60;
    final s = _countdown % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a star rating',
            style: GoogleFonts.outfit()),
        backgroundColor: Colors.orange,
      ));
      return;
    }
    setState(() => _submitting = true);
    await ApiService.submitReview(
      bookingId: widget.bookingId,
      rating: _rating,
      comment: _commentCtrl.text,
    );
    setState(() {
      _submitting = false;
      _reviewDone = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: Text(_jobComplete ? 'Rate Your Service' : 'Job In Progress'),
      ),
      body: _reviewDone
          ? _buildThankYou()
          : _jobComplete
              ? _buildRatingScreen()
              : _buildTrackingScreen(),
    );
  }

  Widget _buildTrackingScreen() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Map
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: _userLocation,
                  initialZoom: 14.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.hirein.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _userLocation,
                        width: 40, height: 40,
                        child: const Icon(Icons.home_rounded, color: Color(0xFF1A237E), size: 32),
                      ),
                      Marker(
                        point: _providerLocation,
                        width: 40, height: 40,
                        child: const Icon(Icons.directions_car_rounded, color: Color(0xFFE50000), size: 36),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Timeline
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTimelineNode('Confirmed', 0),
              _buildTimelineLine(1),
              _buildTimelineNode('En Route', 1),
              _buildTimelineLine(2),
              _buildTimelineNode('Arrived', 2),
            ],
          ),
          const SizedBox(height: 24),

          Center(
            child: Text(
              _status == 0 ? 'Provider Assigned' : _status == 1 ? 'Provider En Route' : 'Provider Arrived',
              style: GoogleFonts.outfit(
                  fontSize: 22, fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A237E))),
          ),
          const SizedBox(height: 6),
          Center(
            child: Text('${widget.providerName} is ${_status == 0 ? "preparing" : "on the way!"}',
                style: GoogleFonts.outfit(
                    fontSize: 14, color: Colors.grey.shade600)),
          ),
          const SizedBox(height: 24),

          // Countdown
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF283593)]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text('Time to arrival',
                    style: GoogleFonts.outfit(
                        color: Colors.white60, fontSize: 13)),
                const SizedBox(height: 4),
                Text(_countdownStr,
                    style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4)),
              ],
            ),
          ),
          const Spacer(),
          
          Text('Appointment: ${widget.slot}',
              style: GoogleFonts.outfit(
                  fontSize: 14, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text('Booking: ${widget.bookingId}',
              style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A237E))),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () => setState(() => _jobComplete = true),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF1A237E),
              side: const BorderSide(color: Color(0xFF1A237E)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Mark as Completed',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineNode(String label, int stepIndex) {
    bool isActive = _status >= stepIndex;
    return Column(
      children: [
        Container(
          width: 24, height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF1A237E) : Colors.grey.shade300,
          ),
          child: isActive ? const Icon(Icons.check_rounded, size: 14, color: Colors.white) : null,
        ),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.outfit(fontSize: 12, color: isActive ? const Color(0xFF1A237E) : Colors.grey.shade500, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
      ],
    );
  }

  Widget _buildTimelineLine(int stepIndex) {
    bool isActive = _status >= stepIndex;
    return Expanded(
      child: Container(
        height: 2,
        color: isActive ? const Color(0xFF1A237E) : Colors.grey.shade300,
        margin: const EdgeInsets.only(bottom: 20), // align with circle centers
      ),
    );
  }

  Widget _buildRatingScreen() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('How was your service?',
              style: GoogleFonts.outfit(
                  fontSize: 22, fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A237E))),
          Text('آپ کی سروس کیسی رہی؟',
              style: GoogleFonts.outfit(
                  fontSize: 14, color: Colors.grey.shade500)),
          const SizedBox(height: 8),
          Text('Rate ${widget.providerName}',
              style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700)),
          const SizedBox(height: 28),
          // Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              final filled = i < _rating;
              return GestureDetector(
                onTap: () => setState(() => _rating = (i + 1).toDouble()),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    filled ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 44,
                    color: filled ? const Color(0xFFFFD700) : Colors.grey.shade300,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _commentCtrl,
            maxLines: 3,
            style: GoogleFonts.outfit(fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Leave a comment... (e.g. Bahut acha kaam kiya)',
              hintStyle: GoogleFonts.outfit(color: Colors.grey.shade400),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submitReview,
              child: _submitting
                  ? const CircularProgressIndicator(
                      strokeWidth: 2, color: Color(0xFF1A237E))
                  : Text('Submit Review',
                      style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w800, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThankYou() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_rounded,
              color: Color(0xFFFFD700), size: 72),
          const SizedBox(height: 20),
          Text('Shukriya!',
              style: GoogleFonts.outfit(
                  fontSize: 28, fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A237E))),
          Text('شکریہ آپ کے ریویو کا',
              style: GoogleFonts.outfit(
                  fontSize: 14, color: Colors.grey.shade500)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            child: Text('Back to Home',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
