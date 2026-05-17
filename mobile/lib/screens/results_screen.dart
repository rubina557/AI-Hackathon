import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/provider_card.dart';
import 'booking_screen.dart';

class ResultsScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const ResultsScreen({super.key, required this.data});

  void _goBook(BuildContext context, Map<String, dynamic> provider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingScreen(
          data: data,
          selectedProvider: provider,
        ),
      ),
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
                            color: Colors.white, fontSize: 13)),
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
            onSelect: () => _goBook(context, provider),
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
                  onSelect: () => _goBook(context, p),
                )),
          ],
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: ElevatedButton(
            onPressed: () => _goBook(context, provider),
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
