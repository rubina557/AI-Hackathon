import 'package:flutter/material.dart';
import 'screens/auth/mode_selection_screen.dart';

void main() {
  runApp(const HireInApp());
}

class HireInApp extends StatelessWidget {
  const HireInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HireIn Premium',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF111B21), // App Background
        primaryColor: const Color(0xFF00A884), // Brand Green
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF00A884),
          secondary: const Color(0xFF00A884),
          surface: const Color(0xFF202C33), // Card Background
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFE9EDEF)),
          bodyMedium: TextStyle(color: Color(0xFFE9EDEF)),
          titleLarge: TextStyle(color: Color(0xFFE9EDEF)),
          titleMedium: TextStyle(color: Color(0xFFE9EDEF)),
        ),
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF202C33),
          foregroundColor: Color(0xFFE9EDEF),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A884),
            foregroundColor: const Color(0xFF111B21),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF202C33),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const ModeSelectionScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
