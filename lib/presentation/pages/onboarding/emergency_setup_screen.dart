import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:neuvox/core/constants/app_colors.dart';
import 'package:neuvox/presentation/widgets/gradient_scaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencySetupScreen extends StatefulWidget {
  const EmergencySetupScreen({super.key});

  @override
  State<EmergencySetupScreen> createState() => _EmergencySetupScreenState();
}

class _EmergencySetupScreenState extends State<EmergencySetupScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.emergency, color: Colors.red, size: 40),
              const SizedBox(height: 16),
              const Text(
                'Emergency SOS',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fadeIn(),
              const SizedBox(height: 8),
              Text(
                'Configure the contact who will receive your location and medical vitals when the Neural Emergency trigger is activated.',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
              
              const SizedBox(height: 32),
              
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Primary Contact Name',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),

              const Spacer(),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveContact,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: _saving 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('ACTIVATE SOS SYSTEM'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveContact() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) return;
    
    setState(() => _saving = true);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sos_contact_name', _nameController.text);
    await prefs.setString('sos_contact_phone', _phoneController.text);
    await prefs.setBool('onboarding_complete', true);
    
    if (mounted) {
       // Onboarding Complete -> Go Home
       Navigator.of(context).pushReplacementNamed('/home');
    }
  }
}
