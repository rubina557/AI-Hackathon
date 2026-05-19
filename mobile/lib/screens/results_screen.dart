import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/provider_card.dart';
import 'payment_screen.dart';

class ResultsScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const ResultsScreen({super.key, required this.data});

  void _showSlotPicker(BuildContext context, Map<String, dynamic> provider) {
    final List<String> slots = List<String>.from(provider['available_slots'] ?? []);
    if (slots.isEmpty) slots.add("2026-05-17 10:00");
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select a Time Slot',
                  style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.w800, color: const Color(0xFF1A237E))),
              const SizedBox(height: 8),
              Text('وقت منتخب کریں',
                  style: GoogleFonts.outfit(fontSize: 14, color: Colors.grey.shade600)),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ...slots.map((slot) => ActionChip(
                    label: Text(slot, style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: const Color(0xFF1A237E))),
                    backgroundColor: const Color(0xFFFFD700).withOpacity(0.2),
                    side: const BorderSide(color: Color(0xFFFFD700)),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PaymentScreen(
                            data: data,
                            selectedProvider: provider,
                            slot: slot,
                          ),
                        ),
                      );
                    },
                  )),
                  ActionChip(
                    label: Text('Pick Custom Date/Time', style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: Colors.white)),
                    backgroundColor: const Color(0xFF1A237E),
                    side: const BorderSide(color: Color(0xFF1A237E)),
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (pickedDate != null && context.mounted) {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null && context.mounted) {
                          final String formattedDate = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')} ${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentScreen(
                                data: data,
                                selectedProvider: provider,
                                slot: formattedDate,
                              ),
                            ),
                          );
                        }
                      }
                    },
                  )
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Map<String, dynamic>.from(data['provider'] ?? {});
    final pricing = Map<String, dynamic>.from(data['pricing'] ?? {});
    final reasoning = data['reasoning'] as String? ?? '';
    final isUrgent = data['is_urgent'] == true;
    final others = List<Map<String, dynamic>>.from(data['other_options'] ?? []);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A237E),
        title: const Text('Best Match Found'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () => Navigator.pushNamed(context, '/logs'),
            tooltip: 'Agent Logs',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          // Reasoning banner
          if (reasoning.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF283593)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFFFFD700), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(reasoning,
                        style: GoogleFonts.outfit(
                            color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),

          // RECOMMENDED card
          ProviderCard(
            provider: provider,
            pricing: pricing,
            isRecommended: true,
            reasoning: reasoning,
            onSelect: () => _showSlotPicker(context, provider),
            buttonLabel: 'Accept & Book',
          ),

          // Other options
          if (others.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text('Other Options',
                  style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A237E))),
            ),
            ...others.map((p) => ProviderCard(
                  provider: p,
                  isRecommended: false,
                  onSelect: () => _showSlotPicker(context, p),
                )),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: ElevatedButton(
            onPressed: () => _showSlotPicker(context, provider),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: const Color(0xFF1A237E),
              minimumSize: const Size.fromHeight(54),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Accept & Book ${provider['name'] ?? ''}',
                style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
