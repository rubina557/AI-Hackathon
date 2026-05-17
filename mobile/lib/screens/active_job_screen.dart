import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  double _rating = 0;
  final TextEditingController _commentCtrl = TextEditingController();
  bool _submitting = false;
  bool _reviewDone = false;
  int _countdown = 1800; // 30 min in seconds
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        t.cancel();
        setState(() => _jobComplete = true);
      }
    });
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1A237E).withOpacity(0.08),
              border: Border.all(color: const Color(0xFF1A237E), width: 2),
            ),
            child: const Icon(Icons.directions_car_rounded,
                color: Color(0xFF1A237E), size: 52),
          ),
          const SizedBox(height: 24),
          Text('Provider En Route',
              style: GoogleFonts.outfit(
                  fontSize: 22, fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A237E))),
          const SizedBox(height: 6),
          Text('${widget.providerName} is on the way!',
              style: GoogleFonts.outfit(
                  fontSize: 14, color: Colors.grey.shade600)),
          const SizedBox(height: 32),
          // Countdown
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
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
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text('Appointment: ${widget.slot}',
              style: GoogleFonts.outfit(
                  fontSize: 14, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text('Booking: ${widget.bookingId}',
              style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A237E))),
          const SizedBox(height: 32),
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
