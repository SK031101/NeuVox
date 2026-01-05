import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../home/dashboard_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  
  bool _consentGiven = false;
  bool _isLoading = false;
  int? _calculatedAge;

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    setState(() => _calculatedAge = age);
  }

  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryPurple,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text = '${picked.day}/${picked.month}/${picked.year}';
        _calculateAge(picked);
      });
    }
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_consentGiven) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please accept the consent agreement to continue'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome to NeuVox',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: AppDimensions.sm),
                const Text(
                  'Help us personalize your experience',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.neutral700,
                  ),
                ),
                
                const SizedBox(height: AppDimensions.xl),
                
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    if (value.length < 2) {
                      return 'Name must be at least 2 characters';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: AppDimensions.md),
                
                TextFormField(
                  controller: _dobController,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    hintText: 'DD/MM/YYYY',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  readOnly: true,
                  onTap: _selectDateOfBirth,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your date of birth';
                    }
                    return null;
                  },
                ),
                
                if (_calculatedAge != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppDimensions.sm),
                    child: Text(
                      'Age: $_calculatedAge years',
                      style: const TextStyle(
                        color: AppColors.neutral500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                
                const SizedBox(height: AppDimensions.md),
                
                TextFormField(
                  initialValue: 'user@microsoft.com',
                  decoration: const InputDecoration(
                    labelText: 'Microsoft Account',
                    prefixIcon: Icon(Icons.email_outlined),
                    enabled: false,
                  ),
                ),
                
                const SizedBox(height: AppDimensions.md),
                
                TextFormField(
                  initialValue: 'NVX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                  decoration: const InputDecoration(
                    labelText: 'Device ID',
                    prefixIcon: Icon(Icons.smartphone_outlined),
                    enabled: false,
                  ),
                ),
                
                const SizedBox(height: AppDimensions.xl),

                Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(color: AppColors.neutral300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _consentGiven,
                            onChanged: (v) => setState(() => _consentGiven = v ?? false),
                          ),
                          const SizedBox(width: AppDimensions.sm),
                          const Expanded(
                            child: Text(
                              'I consent to the collection and processing of data for providing the NeuVox service.',
                              style: TextStyle(fontSize: 14, color: AppColors.neutral700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.md),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignup,
                        child: _isLoading
                            ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Create Profile'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}