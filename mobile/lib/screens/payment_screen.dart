import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'booking_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final Map<String, dynamic> selectedProvider;
  final String slot;

  const PaymentScreen({
    super.key,
    required this.data,
    required this.selectedProvider,
    required this.slot,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedMethod = 'cash';
  bool _isLoading = false;
  final TextEditingController _phoneCtrl = TextEditingController();

  Future<void> _processPaymentAndBook() async {
    if (_selectedMethod != 'cash' && _phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter your phone number for $_selectedMethod', style: GoogleFonts.outfit()),
        backgroundColor: Colors.red.shade700,
      ));
      return;
    }

    setState(() => _isLoading = true);

    // Mock processing delay for wallet
    if (_selectedMethod != 'cash') {
      await Future.delayed(const Duration(seconds: 2));
    }

    final pricing = Map<String, dynamic>.from(widget.data['pricing'] ?? {});
    final isUrgent = widget.data['is_urgent'] == true;

    final res = await ApiService.bookService(
      providerId: widget.selectedProvider['id'] ?? '',
      slot: widget.slot,
      pricing: pricing,
      isUrgent: isUrgent,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res.containsKey('error') || res['booking_id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Booking failed. Please try again.', style: GoogleFonts.outfit()),
        backgroundColor: Colors.red.shade700,
      ));
    } else {
      // Merge booking data into existing data to pass to Confirmation screen
      final finalData = Map<String, dynamic>.from(widget.data);
      finalData['booking_id'] = res['booking_id'];
      finalData['slot'] = res['slot'];
      finalData['notifications'] = res['notifications'];
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BookingScreen(
            data: finalData,
            selectedProvider: widget.selectedProvider,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pricing = Map<String, dynamic>.from(widget.data['pricing'] ?? {});
    final total = pricing['total_pkr'] ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Select Payment Method',
              style: GoogleFonts.outfit(
                  fontSize: 22, fontWeight: FontWeight.w800, color: const Color(0xFF1A237E))),
          const SizedBox(height: 6),
          Text('ادائیگی کا طریقہ منتخب کریں',
              style: GoogleFonts.outfit(
                  fontSize: 14, color: Colors.grey.shade600)),
          const SizedBox(height: 32),

          _buildMethodCard('jazzcash', 'JazzCash', Icons.account_balance_wallet_rounded, const Color(0xFFE50000)),
          const SizedBox(height: 16),
          _buildMethodCard('easypaisa', 'Easypaisa', Icons.account_balance_wallet_rounded, const Color(0xFF00A550)),
          const SizedBox(height: 16),
          _buildMethodCard('cash', 'Cash on Delivery', Icons.money_rounded, const Color(0xFF1A237E)),

          if (_selectedMethod != 'cash') ...[
            const SizedBox(height: 32),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.outfit(fontSize: 16),
              decoration: InputDecoration(
                labelText: '$_selectedMethod Mobile Number',
                labelStyle: GoogleFonts.outfit(color: Colors.grey.shade600),
                prefixIcon: const Icon(Icons.phone_rounded, color: Color(0xFF1A237E)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2),
                ),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _processPaymentAndBook,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: const Color(0xFF1A237E),
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24, height: 24,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Color(0xFF1A237E)),
                  )
                : Text('Pay PKR $total & Book',
                    style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w800, fontSize: 16)),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodCard(String value, String title, IconData icon, Color iconColor) {
    final isSelected = _selectedMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF1A237E).withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title,
                  style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? const Color(0xFF1A237E) : Colors.black87)),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? const Color(0xFF1A237E) : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
