import 'package:flutter/material.dart';
import '../auth/mode_selection_screen.dart';
import 'booking_history_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _language = 'English';

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF202C33),
          title: const Text('Select Language', style: TextStyle(color: Color(0xFFE9EDEF))),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['English', 'Urdu', 'Roman Urdu'].map((lang) {
              return RadioListTile<String>(
                title: Text(lang, style: const TextStyle(color: Color(0xFFE9EDEF))),
                value: lang,
                groupValue: _language,
                activeColor: const Color(0xFF00A884),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _language = val);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Language changed to $val'),
                      backgroundColor: const Color(0xFF00A884),
                    ));
                  }
                },
              );
            }).toList(),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Color(0xFF00A884),
            child: Icon(Icons.person, size: 50, color: Color(0xFF111B21)),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text('User Profile', style: TextStyle(color: Color(0xFFE9EDEF), fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const Center(
            child: Text('0300-XXXXXXX', style: TextStyle(color: Color(0xFF8696A0), fontSize: 16)),
          ),
          const SizedBox(height: 40),
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFF00A884)),
            title: const Text('Language Preference', style: TextStyle(color: Color(0xFFE9EDEF))),
            trailing: Text(_language, style: const TextStyle(color: Color(0xFF8696A0))),
            onTap: _showLanguageDialog,
          ),
          const Divider(color: Colors.white10),
          ListTile(
            leading: const Icon(Icons.history, color: Color(0xFF00A884)),
            title: const Text('Booking History', style: TextStyle(color: Color(0xFFE9EDEF))),
            trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF8696A0), size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookingHistoryScreen()),
              );
            },
          ),
          const Divider(color: Colors.white10),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFF15C6D)),
            title: const Text('Logout', style: TextStyle(color: Color(0xFFF15C6D))),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ModeSelectionScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
