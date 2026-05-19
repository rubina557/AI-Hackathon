import 'package:flutter/material.dart';
import 'login_screen.dart';
// Note: We'll create admin_login and provider_login screens shortly.

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'HireIn',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00A884),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select your mode to continue\nجاری رکھنے کے لیے اپنے طریقہ کار کا انتخاب کریں',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF8696A0),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              _buildModeCard(
                context,
                title: 'Want a service? / سروس چاہیے؟',
                subtitle: 'Book reliable professionals near you\nاپنے قریبی ماہرین سے رابطہ کریں۔',
                icon: Icons.person_search,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen(mode: 'customer')),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildModeCard(
                context,
                title: 'Service Provider / سروس مہیا کار',
                subtitle: 'Manage your bookings and earnings\nاپنی بکنگز اور آمدنی کا انتظام کریں۔',
                icon: Icons.handyman,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen(mode: 'provider')),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildModeCard(
                context,
                title: 'Login as Admin / ایڈمن لاگ ان',
                subtitle: 'Manage disputes and platform metrics\nشکایات اور پلیٹ فارم کے امور سنبھالیں۔',
                icon: Icons.admin_panel_settings,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen(mode: 'admin')),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF202C33),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF005C4B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFFE9EDEF), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE9EDEF))),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 14, color: Color(0xFF8696A0))),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Color(0xFF8696A0), size: 16),
          ],
        ),
      ),
    );
  }
}
