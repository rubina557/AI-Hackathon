import 'package:flutter/material.dart';
import 'booking_tracking_screen.dart';

class BookingScreen extends StatefulWidget {
  final String providerName;
  final double fee;
  
  const BookingScreen({super.key, required this.providerName, required this.fee});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String _selectedSlot = '09:00 AM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Time Slot', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF8696A0))),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildTimeSlot('09:00 AM'),
                _buildTimeSlot('11:30 AM'),
                _buildTimeSlot('02:00 PM'),
                GestureDetector(
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 30)),
                    );
                    if (pickedDate != null && mounted) {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null && mounted) {
                        setState(() {
                          _selectedSlot = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')} ${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: !_selectedSlot.contains('AM') && !_selectedSlot.contains('PM')
                          ? const Color(0xFF00A884).withOpacity(0.2)
                          : const Color(0xFF202C33),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: !_selectedSlot.contains('AM') && !_selectedSlot.contains('PM')
                              ? const Color(0xFF00A884)
                              : Colors.white10,
                          width: 2),
                    ),
                    child: Text(
                      !_selectedSlot.contains('AM') && !_selectedSlot.contains('PM')
                          ? _selectedSlot
                          : 'Custom Date/Time',
                      style: TextStyle(
                        color: !_selectedSlot.contains('AM') && !_selectedSlot.contains('PM')
                            ? const Color(0xFF00A884)
                            : const Color(0xFFE9EDEF),
                        fontWeight: !_selectedSlot.contains('AM') && !_selectedSlot.contains('PM')
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF202C33),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Booking Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFE9EDEF))),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Provider', widget.providerName),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Base Fee', 'PKR ${widget.fee - 150}'),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Travel Fee', 'PKR 100'),
                  const SizedBox(height: 12),
                  _buildSummaryRow('Platform Fee', 'PKR 50'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(color: Colors.white24),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFE9EDEF))),
                      Text('PKR ${widget.fee}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF00A884))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Payment Successful. Booking Confirmed for $_selectedSlot!'),
                      backgroundColor: const Color(0xFF00A884),
                    )
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingTrackingScreen(
                        providerName: widget.providerName,
                        slot: _selectedSlot,
                        fee: widget.fee,
                      ),
                    ),
                  );
                },
                child: Text('Pay PKR ${widget.fee}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String time) {
    final selected = _selectedSlot == time;
    return GestureDetector(
      onTap: () => setState(() => _selectedSlot = time),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF00A884).withOpacity(0.2) : const Color(0xFF202C33),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? const Color(0xFF00A884) : Colors.white10, width: 2),
        ),
        child: Text(
          time, 
          style: TextStyle(
            color: selected ? const Color(0xFF00A884) : const Color(0xFFE9EDEF),
            fontWeight: selected ? FontWeight.bold : FontWeight.normal
          )
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF8696A0), fontSize: 15)),
        Text(value, style: const TextStyle(color: Color(0xFFE9EDEF), fontSize: 15, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
