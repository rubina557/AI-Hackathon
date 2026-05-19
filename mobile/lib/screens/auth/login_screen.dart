import 'package:flutter/material.dart';
import '../customer/home_screen.dart';
import '../provider/provider_home.dart';
import '../admin/admin_dashboard.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  final String mode;
  const LoginScreen({super.key, required this.mode});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _authController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate network request
    setState(() => _isLoading = false);

    if (widget.mode == 'customer') {
      // Customer: Easy login, just phone number
      if (_authController.text.trim().isNotEmpty) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
      } else {
        _showError('Please enter your phone number.');
      }
    } else if (widget.mode == 'provider') {
      // Provider: Hardcoded password check for demo
      if (_authController.text.trim().isNotEmpty && _passwordController.text == 'provider123') {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ProviderHome()), (route) => false);
      } else {
        _showError('Invalid credentials. Hint: use provider123 as password');
      }
    } else if (widget.mode == 'admin') {
      // Admin: strict hardcoded check
      if (_authController.text.trim() == 'admin' && _passwordController.text == 'admin123') {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const AdminDashboard()), (route) => false);
      } else {
        _showError('Unauthorized access.');
      }
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: const Color(0xFFF15C6D),
    ));
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.mode == 'customer' ? 'Customer Login' 
                 : widget.mode == 'provider' ? 'Provider Login' 
                 : 'Admin Login';
    String hint = widget.mode == 'admin' ? 'Username' : 'Phone (03XX-XXXXXXX)';

    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.mode == 'customer' ? Icons.person 
                : widget.mode == 'provider' ? Icons.handyman 
                : Icons.admin_panel_settings,
                size: 80,
                color: widget.mode == 'admin' ? const Color(0xFFF15C6D) : const Color(0xFF00A884),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _authController,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(color: Color(0xFF8696A0)),
                  filled: true,
                  fillColor: const Color(0xFF202C33),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                style: const TextStyle(color: Color(0xFFE9EDEF)),
                keyboardType: widget.mode == 'admin' ? TextInputType.text : TextInputType.phone,
              ),
              if (widget.mode == 'admin' || widget.mode == 'provider') ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Color(0xFF8696A0)),
                    filled: true,
                    fillColor: const Color(0xFF202C33),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  style: const TextStyle(color: Color(0xFFE9EDEF)),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.mode == 'admin' ? const Color(0xFFF15C6D) : const Color(0xFF00A884),
                    foregroundColor: const Color(0xFF111B21)
                  ),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Color(0xFF111B21))
                    : const Text('Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              if (widget.mode != 'admin') ...[
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationScreen(mode: widget.mode)),
                    );
                  },
                  child: const Text("Don't have an account? Register here", style: TextStyle(color: Color(0xFF00A884))),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
