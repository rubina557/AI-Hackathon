import 'package:flutter/material.dart';
import 'results_screen.dart';

class ThinkingScreen extends StatefulWidget {
  const ThinkingScreen({super.key});

  @override
  State<ThinkingScreen> createState() => _ThinkingScreenState();
}

class _ThinkingScreenState extends State<ThinkingScreen> {
  int _step = 0;
  final List<String> _steps = [
    'Understanding your request...',
    'Finding providers near you...',
    'Ranking by rating & reliability...',
    'Calculating travel fees...',
    'Selecting your best match...'
  ];

  @override
  void initState() {
    super.initState();
    _cycleSteps();
  }

  void _cycleSteps() async {
    for (int i = 0; i < 5; i++) {
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) setState(() => _step = i);
    }
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResultsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simulating radar/pulse
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00A884).withOpacity(0.1),
                border: Border.all(color: const Color(0xFF00A884), width: 2),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF00A884).withOpacity(0.4), blurRadius: 30, spreadRadius: 10),
                ]
              ),
              child: const Icon(Icons.psychology, size: 50, color: Color(0xFF00A884)),
            ),
            const SizedBox(height: 40),
            Text(
              _steps[_step],
              style: const TextStyle(color: Color(0xFFE9EDEF), fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 250,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (_step + 1) / 5,
                  color: const Color(0xFF00A884),
                  backgroundColor: const Color(0xFF202C33),
                  minHeight: 8,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
