import 'package:flutter/material.dart';
import '../customer/home_screen.dart';
import '../provider/provider_home.dart';

class RegistrationScreen extends StatefulWidget {
  final String mode;
  const RegistrationScreen({super.key, required this.mode});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Provider-specific fields
  String _selectedSkill = 'Electrician';
  final TextEditingController _experienceController = TextEditingController();
  bool _cnicFrontUploaded = false;
  bool _cnicBackUploaded = false;
  
  bool _isLoading = false;

  void _register() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate network request
    setState(() => _isLoading = false);

    if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
      _showError('Please fill in all required fields.');
      return;
    }

    if (widget.mode == 'customer') {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
    } else if (widget.mode == 'provider') {
      if (_passwordController.text.trim().isEmpty) {
        _showError('Please enter a password.');
        return;
      }
      if (_experienceController.text.trim().isEmpty) {
        _showError('Please enter your experience in years.');
        return;
      }
      if (!_cnicFrontUploaded || !_cnicBackUploaded) {
        _showError('Please upload both CNIC Front and Back images.');
        return;
      }
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ProviderHome()), (route) => false);
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
    String title = widget.mode == 'customer' ? 'Customer Registration' : 'Provider Registration';

    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.mode == 'customer' ? Icons.person_add : Icons.handyman,
                size: 80,
                color: const Color(0xFF00A884),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  hintStyle: const TextStyle(color: Color(0xFF8696A0)),
                  filled: true,
                  fillColor: const Color(0xFF202C33),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                style: const TextStyle(color: Color(0xFFE9EDEF)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: 'Phone (03XX-XXXXXXX)',
                  hintStyle: const TextStyle(color: Color(0xFF8696A0)),
                  filled: true,
                  fillColor: const Color(0xFF202C33),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                style: const TextStyle(color: Color(0xFFE9EDEF)),
                keyboardType: TextInputType.phone,
              ),
              if (widget.mode == 'provider') ...[
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedSkill,
                  dropdownColor: const Color(0xFF202C33),
                  style: const TextStyle(color: Color(0xFFE9EDEF)),
                  decoration: InputDecoration(
                    labelText: 'Select Skill',
                    labelStyle: const TextStyle(color: Color(0xFF8696A0)),
                    filled: true,
                    fillColor: const Color(0xFF202C33),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  items: ['Electrician', 'Plumber', 'AC Repair', 'Mechanic', 'Painter', 'Carpenter'].map((skill) {
                    return DropdownMenuItem<String>(
                      value: skill,
                      child: Text(skill),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedSkill = val);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _experienceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Experience (Years)',
                    hintStyle: const TextStyle(color: Color(0xFF8696A0)),
                    filled: true,
                    fillColor: const Color(0xFF202C33),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  style: const TextStyle(color: Color(0xFFE9EDEF)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _cnicFrontUploaded ? const Color(0xFF00A884).withOpacity(0.2) : const Color(0xFF202C33),
                              foregroundColor: _cnicFrontUploaded ? const Color(0xFF00A884) : const Color(0xFF8696A0),
                              side: BorderSide(color: _cnicFrontUploaded ? const Color(0xFF00A884) : Colors.white10),
                            ),
                            onPressed: () {
                              setState(() => _cnicFrontUploaded = true);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CNIC Front Photo added!')));
                            },
                            icon: Icon(_cnicFrontUploaded ? Icons.check_circle : Icons.add_a_photo),
                            label: const Text('CNIC Front'),
                          ),
                          if (_cnicFrontUploaded) ...[
                            const SizedBox(height: 8),
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F3E36),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF00A884), width: 1.5),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40, height: 60,
                                    color: Colors.white12,
                                    child: const Icon(Icons.person, color: Colors.white54, size: 24),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text('CNIC FRONT', style: TextStyle(color: Color(0xFF00A884), fontSize: 7, fontWeight: FontWeight.bold)),
                                        SizedBox(height: 2),
                                        Text('Sajid Khan', style: TextStyle(color: Color(0xFFE9EDEF), fontSize: 9, fontWeight: FontWeight.bold)),
                                        Text('35201-XXXXXXX-X', style: TextStyle(color: Color(0xFF8696A0), fontSize: 8)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _cnicBackUploaded ? const Color(0xFF00A884).withOpacity(0.2) : const Color(0xFF202C33),
                              foregroundColor: _cnicBackUploaded ? const Color(0xFF00A884) : const Color(0xFF8696A0),
                              side: BorderSide(color: _cnicBackUploaded ? const Color(0xFF00A884) : Colors.white10),
                            ),
                            onPressed: () {
                              setState(() => _cnicBackUploaded = true);
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CNIC Back Photo added!')));
                            },
                            icon: Icon(_cnicBackUploaded ? Icons.check_circle : Icons.add_a_photo),
                            label: const Text('CNIC Back'),
                          ),
                          if (_cnicBackUploaded) ...[
                            const SizedBox(height: 8),
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F3E36),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFF00A884), width: 1.5),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('CNIC BACK', style: TextStyle(color: Color(0xFF00A884), fontSize: 7, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 2),
                                  Text('Present: Lahore, Punjab', style: TextStyle(color: Color(0xFFE9EDEF), fontSize: 8)),
                                  Text('Permanent: Lahore, Punjab', style: TextStyle(color: Color(0xFF8696A0), fontSize: 7)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
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
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A884),
                    foregroundColor: const Color(0xFF111B21)
                  ),
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Color(0xFF111B21))
                    : const Text('Register', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Already have an account? Login here', style: TextStyle(color: Color(0xFF00A884))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
