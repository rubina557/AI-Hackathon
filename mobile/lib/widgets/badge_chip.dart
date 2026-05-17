import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BadgeChip extends StatelessWidget {
  final String label;
  final bool isGold;

  const BadgeChip({super.key, required this.label, this.isGold = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isGold ? const Color(0xFFFFD700) : const Color(0xFF1A237E).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isGold ? const Color(0xFFFFD700) : const Color(0xFF1A237E).withOpacity(0.3),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isGold ? const Color(0xFF1A237E) : const Color(0xFF1A237E),
        ),
      ),
    );
  }
}
