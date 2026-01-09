import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:neuvox/core/constants/app_colors.dart';
import 'package:neuvox/presentation/widgets/gradient_scaffold.dart';

class MedicalIntakeScreen extends StatefulWidget {
  const MedicalIntakeScreen({super.key});

  @override
  State<MedicalIntakeScreen> createState() => _MedicalIntakeScreenState();
}

class _MedicalIntakeScreenState extends State<MedicalIntakeScreen> {
  String? _selectedCondition;
  double _severity = 0.5;
  bool _submitting = false;

  final List<String> _conditions = [
    'Amyotrophic Lateral Sclerosis (ALS)',
    'Cerebral Palsy',
    'Stroke Recovery',
    'Spinal Cord Injury',
    'Multiple Sclerosis',
    'Other / Non-Medical',
  ];

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Medical Profile',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate().fadeIn().moveY(begin: 10, end: 0),
              const SizedBox(height: 8),
              Text(
                'This information calibrates the Neural Decoder for your specific physiology. HIPAA Compliant.',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ).animate().fadeIn(delay: 100.ms),
              
              const SizedBox(height: 32),
              
              // Condition Selector
              const Text('Primary Condition', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCondition,
                    isExpanded: true,
                    hint: const Text('Select Condition', style: TextStyle(color: Colors.white54)),
                    dropdownColor: Colors.grey[900],
                    style: const TextStyle(color: Colors.white),
                    items: _conditions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) => setState(() => _selectedCondition = val),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              
              // Severity Slider
              const Text('Symptom Severity (Self-Reported)', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Mild', style: TextStyle(color: Colors.white54, fontSize: 12)),
                  Expanded(
                    child: Slider(
                      value: _severity,
                      activeColor: AppColors.accent,
                      onChanged: (val) => setState(() => _severity = val),
                    ),
                  ),
                  const Text('Severe', style: TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
              
              const Spacer(),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _selectedCondition == null ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: _submitting 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('CONTINUE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    setState(() => _submitting = true);
    // Simulate API call to Azure Health Bot
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
       // Navigate to next step (Emergency Setup)
       Navigator.of(context).pushReplacementNamed('/emergency_setup'); // Or push
    }
  }
}
