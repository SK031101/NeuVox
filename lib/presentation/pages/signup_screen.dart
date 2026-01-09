import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neuvox/core/constants/app_colors.dart';
import 'package:neuvox/presentation/widgets/gradient_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController(); // Pre-filled from MS logic usually
  final _dobController = TextEditingController();
  final _deviceIdController = TextEditingController();
  
  int? _age;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Simulate auto-generated Device ID
    _deviceIdController.text = "NVX-${const Uuid().v4().substring(0, 8).toUpperCase()}";
    // Simulate email from auth
    _emailController.text = "user@microsoft.com"; 
  }

  void _calculateAge(DateTime dob) {
    setState(() {
      _age = DateTime.now().year - dob.year;
      if (DateTime.now().month < dob.month || 
          (DateTime.now().month == dob.month && DateTime.now().day < dob.day)) {
        _age = _age! - 1;
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.backgroundLight,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      _calculateAge(picked);
    }
  }

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final authProvider = context.read<AuthProvider>();
      // Simulate account creation
      await Future.delayed(const Duration(seconds: 2));
      await authProvider.login(); // Force login state
      
      if (!mounted) return;
       Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false,
       );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Complete Profile",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Please provide patient details for device calibration.",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),

                // Name
                _buildLabel("FULL NAME"),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("John Doe"),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),
                const SizedBox(height: 24),

                // Email
                _buildLabel("MICROSOFT ACCOUNT"),
                TextFormField(
                  controller: _emailController,
                  enabled: false,
                  style: const TextStyle(color: Colors.white70),
                  decoration: _inputDecoration("email@domain.com"),
                ),
                const SizedBox(height: 24),

                // DOB & Age 
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("DATE OF BIRTH"),
                          TextFormField(
                            controller: _dobController,
                            readOnly: true,
                            onTap: () => _selectDate(context),
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration("YYYY-MM-DD")
                                .copyWith(suffixIcon: const Icon(Icons.calendar_today, color: AppColors.primary)),
                            validator: (v) => v!.isEmpty ? "Required" : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel("AGE"),
                          Container(
                            height: 56, // Match input height roughly
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.backgroundLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                _age?.toString() ?? "-",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Device ID
                _buildLabel("ASSIGNED DEVICE ID"),
                TextFormField(
                  controller: _deviceIdController,
                  enabled: false,
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  decoration: _inputDecoration(""),
                ),
                
                const SizedBox(height: 48),
                
                // Submit
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignup,
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("ACTIVATE DEVICE"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary, 
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
      filled: true,
      fillColor: AppColors.backgroundLight,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}
