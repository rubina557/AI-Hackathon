import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'badge_chip.dart';

class ProviderCard extends StatelessWidget {
  final Map<String, dynamic> provider;
  final Map<String, dynamic>? pricing;
  final bool isRecommended;
  final String? reasoning;
  final VoidCallback? onSelect;
  final String buttonLabel;

  const ProviderCard({
    super.key,
    required this.provider,
    this.pricing,
    this.isRecommended = false,
    this.reasoning,
    this.onSelect,
    this.buttonLabel = 'Select Instead',
  });

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final badges = List<String>.from(provider['badges'] ?? []);
    final etaMinutes = pricing?['eta_minutes'];
    final totalPkr = pricing?['total_pkr'];
    final dist = provider['distance_km'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isRecommended
            ? Border.all(color: const Color(0xFFFFD700), width: 2.5)
            : Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: isRecommended
                ? const Color(0xFFFFD700).withOpacity(0.18)
                : Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isRecommended)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('⭐ RECOMMENDED',
                    style: GoogleFonts.outfit(
                        fontSize: 11, fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A237E))),
              ),
            Row(
              children: [
                // Avatar
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A237E),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(_initials(provider['name'] ?? 'NA'),
                        style: GoogleFonts.outfit(
                            fontSize: 18, fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(provider['name'] ?? '',
                                style: GoogleFonts.outfit(
                                    fontSize: 15, fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A237E))),
                          ),
                          if (provider['verified'] == true)
                            const Icon(Icons.verified, color: Color(0xFF1A237E), size: 16),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(children: [
                        const Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 16),
                        const SizedBox(width: 3),
                        Text('${provider['rating']}',
                            style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600, fontSize: 13)),
                        Text(' (${provider['review_count']} reviews)',
                            style: GoogleFonts.outfit(
                                fontSize: 12, color: Colors.grey.shade600)),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Badges
            if (badges.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: badges
                    .map((b) => BadgeChip(
                        label: b,
                        isGold: b == 'Top Rated' || b == 'Fastest ETA'))
                    .toList(),
              ),
            const SizedBox(height: 12),
            // Stats row
            Row(children: [
              _statItem(Icons.location_on_rounded, '${dist ?? "--"} km', Colors.blue.shade700),
              const SizedBox(width: 16),
              _statItem(Icons.work_rounded, provider['skill_level'] ?? '', Colors.purple.shade700),
              if (etaMinutes != null) ...[
                const SizedBox(width: 16),
                _statItem(Icons.timer_rounded, '~$etaMinutes mins', Colors.orange.shade700),
              ],
              const Spacer(),
              if (totalPkr != null)
                Text('PKR ${totalPkr.toStringAsFixed(0)}',
                    style: GoogleFonts.outfit(
                        fontSize: 16, fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A237E))),
            ]),
            // Reasoning
            if (reasoning != null && reasoning!.isNotEmpty) ...[
              const SizedBox(height: 10),
              ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(bottom: 8),
                title: Text('View Reasoning',
                    style: GoogleFonts.outfit(
                        fontSize: 13, color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500)),
                children: [
                  Text(reasoning!,
                      style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey.shade700)),
                ],
              ),
            ],
            if (onSelect != null) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onSelect,
                  child: Text(buttonLabel),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _statItem(IconData icon, String label, Color color) {
    return Row(children: [
      Icon(icon, size: 14, color: color),
      const SizedBox(width: 3),
      Text(label,
          style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey.shade700,
              fontWeight: FontWeight.w500)),
    ]);
  }
}
