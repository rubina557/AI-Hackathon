import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PipelineProgress extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const PipelineProgress({
    super.key,
    required this.currentStep,
    this.totalSteps = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (i) {
            final done = i < currentStep;
            final active = i == currentStep;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 6,
                decoration: BoxDecoration(
                  color: done
                      ? const Color(0xFFFFD700)
                      : active
                          ? const Color(0xFFFFD700).withOpacity(0.5)
                          : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Text(
          'Step ${currentStep + 1} of $totalSteps',
          style: GoogleFonts.outfit(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
