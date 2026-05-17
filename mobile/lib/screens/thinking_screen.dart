import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../widgets/pipeline_progress.dart';
import 'results_screen.dart';

const _steps = [
  'Understanding your request... 🧠',
  'Finding providers nearby... 🔍',
  'Ranking by rating & distance... 📊',
  'Calculating travel fees... 💰',
  'Selecting best match... ⚡',
];

class ThinkingScreen extends StatefulWidget {
  final String message;
  const ThinkingScreen({super.key, required this.message});

  @override
  State<ThinkingScreen> createState() => _ThinkingScreenState();
}

class _ThinkingScreenState extends State<ThinkingScreen>
    with SingleTickerProviderStateMixin {
  int _step = 0;
  Timer? _timer;
  late AnimationController _pulse;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // Step timer — advances every 2 seconds
    _timer = Timer.periodic(const Duration(seconds: 2), (t) {
      if (_step < _steps.length - 1) {
        setState(() => _step++);
      }
    });

    // Fire API call
    _callApi();
  }

  Future<void> _callApi() async {
    final result = await ApiService.chat(message: widget.message);
    _timer?.cancel();
    if (!mounted) return;
    if (result.containsKey('error') || result['booking_id'] == null) {
      // Navigate back with error message
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result['response'] ?? 'کچھ غلط ہو گیا۔ دوبارہ کوشش کریں۔',
            style: GoogleFonts.outfit()),
        backgroundColor: Colors.red.shade700,
      ));
    } else {
      setState(() => _done = true);
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ResultsScreen(data: result)),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulse animation
              AnimatedBuilder(
                animation: _pulse,
                builder: (_, __) => Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer ring
                    Container(
                      width: 140 + _pulse.value * 20,
                      height: 140 + _pulse.value * 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05 + _pulse.value * 0.05),
                      ),
                    ),
                    // Mid ring
                    Container(
                      width: 110 + _pulse.value * 10,
                      height: 110 + _pulse.value * 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                    // Core
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFFFD700),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFD700).withOpacity(0.4),
                            blurRadius: 24,
                            spreadRadius: 4,
                          )
                        ],
                      ),
                      child: const Icon(Icons.bolt_rounded,
                          color: Color(0xFF1A237E), size: 42),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              Text(
                _steps[_step],
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '"${widget.message}"',
                style: GoogleFonts.outfit(
                  color: Colors.white60,
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 40),
              PipelineProgress(currentStep: _step),
              const SizedBox(height: 32),
              // Step labels
              ...List.generate(_steps.length, (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 20, height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < _step
                            ? const Color(0xFFFFD700)
                            : i == _step
                                ? Colors.white
                                : Colors.white24,
                      ),
                      child: i < _step
                          ? const Icon(Icons.check, size: 12,
                              color: Color(0xFF1A237E))
                          : i == _step
                              ? const Icon(Icons.circle, size: 8,
                                  color: Color(0xFF1A237E))
                              : null,
                    ),
                    const SizedBox(width: 10),
                    Text('Step ${i + 1}: ${_steps[i]}',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: i <= _step ? Colors.white : Colors.white38,
                          fontWeight: i == _step
                              ? FontWeight.w600
                              : FontWeight.w400,
                        )),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
