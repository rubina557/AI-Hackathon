import 'package:flutter/material.dart';

class BookingTrackingScreen extends StatefulWidget {
  final String providerName;
  final String slot;
  final double fee;

  const BookingTrackingScreen({
    super.key,
    required this.providerName,
    required this.slot,
    required this.fee,
  });

  @override
  State<BookingTrackingScreen> createState() => _BookingTrackingScreenState();
}

class _BookingTrackingScreenState extends State<BookingTrackingScreen> {
  int _currentStep = 0; // 0: Confirmed, 1: 1-Hour Reminder, 2: En Route, 3: Completed
  bool _notificationTriggered = false;
  String _notificationMessage = "";

  void _triggerNotification(String msg) {
    setState(() {
      _notificationTriggered = true;
      _notificationMessage = msg;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.notifications_active, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(msg, style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        backgroundColor: const Color(0xFF00A884),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      appBar: AppBar(
        title: const Text('Booking Follow-Up & Tracker'),
        backgroundColor: const Color(0xFF202C33),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header Card
            Container(
              padding: const EdgeInsets.all(20),
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
                      const Text(
                        'Booking ID: BK-4829',
                        style: TextStyle(color: Color(0xFF00A884), fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      _buildStatusChip(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 8),
                  _buildDetailRow('Provider', widget.providerName),
                  const SizedBox(height: 8),
                  _buildDetailRow('Scheduled Slot', widget.slot),
                  const SizedBox(height: 8),
                  _buildDetailRow('Total Paid', 'PKR ${widget.fee}'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            const Text(
              'Automated Follow-Up Timeline',
              style: TextStyle(color: Color(0xFFE9EDEF), fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Real-time automated status updates and scheduled alerts.',
              style: TextStyle(color: Color(0xFF8696A0), fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Timeline Steps
            _buildTimelineStep(
              stepIndex: 0,
              title: 'Booking Confirmed',
              subtitle: 'Agent 6 registered transaction to bookings.csv',
              timeText: 'Just Now',
              icon: Icons.check_circle,
              isDone: _currentStep >= 0,
            ),
            _buildTimelineStep(
              stepIndex: 1,
              title: '1-Hour Reminder Alert',
              subtitle: 'Automated SMS: Technician arriving in 1 hour',
              timeText: 'Scheduled',
              icon: Icons.alarm,
              isDone: _currentStep >= 1,
            ),
            _buildTimelineStep(
              stepIndex: 2,
              title: 'Technician Dispatch (En Route)',
              subtitle: _currentStep >= 2 
                  ? '🚗 Ali Hassan is en route! Live ETA: 12 mins' 
                  : 'Scheduled at dispatch time',
              timeText: _currentStep >= 2 ? 'Active' : 'Scheduled',
              icon: Icons.directions_car,
              isDone: _currentStep >= 2,
            ),
            _buildTimelineStep(
              stepIndex: 3,
              title: 'Service Completed',
              subtitle: _currentStep >= 3 
                  ? 'Quality Assurance Agent 8 is awaiting star feedback' 
                  : 'Awaiting completion confirmation',
              timeText: _currentStep >= 3 ? 'Completed' : 'Pending',
              icon: Icons.stars,
              isDone: _currentStep >= 3,
            ),

            if (_currentStep == 2) ...[
              const SizedBox(height: 20),
              // Live Map Tracker Simulation Container
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF0F2D24),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF00A884), width: 1.5),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.my_location, color: Color(0xFF00A884), size: 36),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${widget.providerName} is on the way!', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 4),
                          const Text('Live ETA: 12 minutes | Distance: 2.3 km', style: TextStyle(color: Color(0xFF8696A0), fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 40),

            // Demo Simulation Controls
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF202C33).withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.science, color: Color(0xFF00A884)),
                      SizedBox(width: 10),
                      Text(
                        'HACKATHON DEMO CONTROLS',
                        style: TextStyle(color: Color(0xFF00A884), fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Simulate background automation triggers live for the judges:',
                    style: TextStyle(color: Color(0xFF8696A0), fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentStep == 0 ? const Color(0xFF00A884) : const Color(0xFF202C33),
                            foregroundColor: _currentStep == 0 ? const Color(0xFF111B21) : const Color(0xFFE9EDEF),
                          ),
                          onPressed: _currentStep == 0 ? () {
                            setState(() => _currentStep = 1);
                            _triggerNotification('⏰ Reminder Alert Triggered: ${widget.providerName} arriving in 1 hr!');
                          } : null,
                          child: const Text('1. Trigger Reminder', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentStep == 1 ? const Color(0xFF00A884) : const Color(0xFF202C33),
                            foregroundColor: _currentStep == 1 ? const Color(0xFF111B21) : const Color(0xFFE9EDEF),
                          ),
                          onPressed: _currentStep == 1 ? () {
                            setState(() => _currentStep = 2);
                            _triggerNotification('🚗 Dispatch Event: ${widget.providerName} is en route! ETA: 12m');
                          } : null,
                          child: const Text('2. Trigger Dispatch', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentStep == 2 ? const Color(0xFF00A884) : const Color(0xFF202C33),
                            foregroundColor: _currentStep == 2 ? const Color(0xFF111B21) : const Color(0xFFE9EDEF),
                          ),
                          onPressed: _currentStep == 2 ? () {
                            setState(() => _currentStep = 3);
                            _triggerNotification('⭐ Job Completed! Please rate ${widget.providerName}.');
                          } : null,
                          child: const Text('3. Trigger Complete', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  if (_currentStep == 3) ...[
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A884),
                        foregroundColor: const Color(0xFF111B21),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        // Open mock review form
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: const Color(0xFF202C33),
                            title: Text('Rate ${widget.providerName}', style: const TextStyle(color: Color(0xFFE9EDEF))),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 36),
                                    Icon(Icons.star, color: Colors.amber, size: 36),
                                    Icon(Icons.star, color: Colors.amber, size: 36),
                                    Icon(Icons.star, color: Colors.amber, size: 36),
                                    Icon(Icons.star, color: Colors.amber, size: 36),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: 'Share your feedback...',
                                    hintStyle: const TextStyle(color: Color(0xFF8696A0)),
                                    filled: true,
                                    fillColor: const Color(0xFF111B21),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                  ),
                                  style: const TextStyle(color: Color(0xFFE9EDEF)),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Feedback submitted successfully! Agent 8 has updated provider ranking score.'),
                                      backgroundColor: Color(0xFF00A884),
                                    ),
                                  );
                                  Navigator.popUntil(context, (route) => route.isFirst);
                                },
                                child: const Text('SUBMIT', style: TextStyle(color: Color(0xFF00A884), fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.star_rate),
                      label: const Text('SUBMIT QUALITY RATINGS (AGENT 8)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    String text = "Confirmed";
    Color bg = const Color(0xFF005C4B).withOpacity(0.3);
    Color fg = const Color(0xFF00A884);

    if (_currentStep == 1) {
      text = "Reminder Sent";
      bg = Colors.blue.withOpacity(0.15);
      fg = Colors.blueAccent;
    } else if (_currentStep == 2) {
      text = "En Route";
      bg = Colors.orange.withOpacity(0.15);
      fg = Colors.orangeAccent;
    } else if (_currentStep == 3) {
      text = "Completed";
      bg = Colors.green.withOpacity(0.15);
      fg = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(30)),
      child: Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildDetailRow(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF8696A0), fontSize: 14)),
        Text(val, style: const TextStyle(color: Color(0xFFE9EDEF), fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildTimelineStep({
    required int stepIndex,
    required String title,
    required String subtitle,
    required String timeText,
    required IconData icon,
    required bool isDone,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Circle and Line
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isDone ? const Color(0xFF00A884) : const Color(0xFF202C33),
                  shape: BoxShape.circle,
                  border: Border.all(color: isDone ? const Color(0xFF00A884) : Colors.white24, width: 2),
                ),
                child: Icon(icon, color: isDone ? const Color(0xFF111B21) : Colors.white30, size: 14),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: stepIndex == 3 
                      ? Colors.transparent 
                      : (isDone && _currentStep > stepIndex ? const Color(0xFF00A884) : Colors.white24),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDone ? const Color(0xFFE9EDEF) : const Color(0xFF8696A0),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      timeText,
                      style: TextStyle(
                        color: isDone ? const Color(0xFF00A884) : const Color(0xFF8696A0),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Color(0xFF8696A0), fontSize: 13),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
