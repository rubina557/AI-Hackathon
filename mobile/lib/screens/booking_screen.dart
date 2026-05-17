import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'active_job_screen.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic> selectedProvider;

  const BookingScreen({
    super.key,
    required this.data,
    required this.selectedProvider,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _checkAnim;
  late Animation<double> _scale;
  bool _priceExpanded = false;

  @override
  void initState() {
    super.initState();
    _checkAnim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scale = CurvedAnimation(parent: _checkAnim, curve: Curves.elasticOut);
    Future.delayed(const Duration(milliseconds: 300), _checkAnim.forward);
  }

  @override
  void dispose() {
    _checkAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bid = widget.data['booking_id'] ?? 'BK-????';
    final slot = widget.data['slot'] ?? '--';
    final pricing = Map<String, dynamic>.from(widget.data['pricing'] ?? {});
    final provider = widget.selectedProvider;
    final notifications =
        List<Map<String, dynamic>>.from(widget.data['notifications'] ?? []);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text('Booking Confirmed'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded),
            onPressed: () =>
                Navigator.popUntil(context, (r) => r.isFirst),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        children: [
          // Checkmark animation
          ScaleTransition(
            scale: _scale,
            child: Container(
              width: 96, height: 96,
              margin: const EdgeInsets.symmetric(horizontal: 140),
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 52),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text('Booking Confirmed!',
                style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A237E))),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text('آپ کی بکنگ کامیابی سے ہو گئی',
                style: GoogleFonts.outfit(
                    fontSize: 13, color: Colors.grey.shade500)),
          ),
          const SizedBox(height: 24),

          // Booking ID
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: bid));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Booking ID copied!',
                      style: GoogleFonts.outfit()),
                  backgroundColor: const Color(0xFF1A237E),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF1A237E), Color(0xFF283593)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('BOOKING ID',
                        style: GoogleFonts.outfit(
                            color: Colors.white60, fontSize: 11,
                            letterSpacing: 1.2)),
                    const SizedBox(height: 4),
                    Text(bid,
                        style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2)),
                  ]),
                  const Icon(Icons.copy_rounded,
                      color: Color(0xFFFFD700), size: 22),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Provider details card
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Provider Details'),
                const SizedBox(height: 12),
                _row(Icons.person_rounded, provider['name'] ?? ''),
                _row(Icons.star_rounded, '${provider['rating']} Rating'),
                _row(Icons.location_on_rounded,
                    '${provider['distance_km'] ?? '--'} km away'),
                _row(Icons.schedule_rounded, slot),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Price breakdown
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () =>
                      setState(() => _priceExpanded = !_priceExpanded),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionTitle('Price Breakdown'),
                      Icon(
                        _priceExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: const Color(0xFF1A237E),
                      ),
                    ],
                  ),
                ),
                if (_priceExpanded) ...[
                  const SizedBox(height: 12),
                  _priceRow('Base Fee', pricing['base_fee']),
                  _priceRow('Distance Fee', pricing['distance_fee']),
                  if ((pricing['urgency_fee'] ?? 0) > 0)
                    _priceRow('Urgency Fee', pricing['urgency_fee']),
                  if ((pricing['surge_fee'] ?? 0) > 0)
                    _priceRow('Peak Hour Surge', pricing['surge_fee']),
                  _priceRow('Platform Fee', pricing['platform_cut']),
                  const Divider(),
                  _priceRow('Total', pricing['total_pkr'], bold: true),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Notification timeline
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle('Notification Timeline'),
                const SizedBox(height: 12),
                ...notifications.map((n) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 8, height: 8,
                            margin: const EdgeInsets.only(top: 5),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFD700),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(n['message'] ?? '',
                                style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    color: Colors.grey.shade700)),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // CTA buttons
          Row(children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call_rounded),
                label: Text('Call Provider',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1A237E),
                  side: const BorderSide(color: Color(0xFF1A237E), width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ActiveJobScreen(
                      bookingId: bid,
                      providerName: provider['name'] ?? '',
                      slot: slot,
                    ),
                  ),
                ),
                icon: const Icon(Icons.track_changes_rounded),
                label: Text('Track Job',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ],
        ),
        child: child,
      );

  Widget _sectionTitle(String t) => Text(t,
      style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF1A237E)));

  Widget _row(IconData icon, String label) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(children: [
          Icon(icon, size: 16, color: const Color(0xFF1A237E)),
          const SizedBox(width: 8),
          Text(label,
              style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey.shade700)),
        ]),
      );

  Widget _priceRow(String label, dynamic amount, {bool bold = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
                    color: Colors.grey.shade700)),
            Text('PKR ${(amount ?? 0).toStringAsFixed(0)}',
                style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                    color: bold
                        ? const Color(0xFF1A237E)
                        : Colors.grey.shade800)),
          ],
        ),
      );
}
