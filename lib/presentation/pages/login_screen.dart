import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:neuvox/core/di/service_locator.dart';
import 'package:neuvox/core/services/biometric_service.dart';
import 'package:neuvox/presentation/pages/onboarding/medical_intake_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:neuvox/core/constants/app_colors.dart';
import 'package:neuvox/presentation/widgets/gradient_scaffold.dart';
import 'package:neuvox/presentation/providers/auth_provider.dart';
import 'home_screen.dart'; 
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  
  // Microsoft Login Button
  Widget _buildMicrosoftLoginButton(bool isLoading) {
    return ElevatedButton(
      onPressed: isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Microsoft white
        foregroundColor: Colors.black, // Text black
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: isLoading 
        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               // Microsoft Logo (Simple colored squares simulation)
              SizedBox(
                width: 20,
                height: 20,
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    ColoredBox(color: Color(0xFFF25022)),
                    ColoredBox(color: Color(0xFF7FBA00)),
                    ColoredBox(color: Color(0xFF00A4EF)),
                    ColoredBox(color: Color(0xFFFFB900)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Sign in with Microsoft",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
    ).animate().fadeIn(delay: 500.ms).moveY(begin: 30);
  }

  @override
  Widget build(BuildContext context) {
    // Watch Auth Status for loading UI
    final authStatus = context.watch<AuthProvider>().status;
    final isAuthLoading = authStatus == AuthStatus.loading;

    return GradientScaffold(
      body: Padding(
         padding: const EdgeInsets.all(24.0),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.stretch,
           children: [
             const Spacer(),
             
             // Hero Image / Icon
             Icon(
               Icons.psychology, 
               size: 100, 
               color: AppColors.primary.withOpacity(0.8)
             ).animate().scale(duration: 1.seconds).fade(),
             
             const SizedBox(height: 32),
             
             const Text(
               "Welcome back",
               textAlign: TextAlign.center,
               style: TextStyle(
                 fontSize: 32,
                 fontWeight: FontWeight.bold,
                 color: AppColors.textPrimary,
               ),
             ).animate().fadeIn().moveY(begin: 20),
             
             const SizedBox(height: 16),
             
             const Text(
               "Sign in to access your personalized voice assistant.",
               textAlign: TextAlign.center,
               style: TextStyle(
                 fontSize: 16,
                 color: AppColors.textSecondary,
               ),
             ).animate().fadeIn(delay: 200.ms),
             
             const Spacer(),

             // Biometric Login (Microsoft Style)
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _handleBiometricLogin,
                  icon: const Icon(Icons.fingerprint, color: AppColors.primary),
                  label: const Text("Sign in with Windows Hello / Face ID"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms),
                
             const SizedBox(height: 24),
             
             // Microsoft Login Button
             _buildMicrosoftLoginButton(isAuthLoading || _isLoading),
             
             const SizedBox(height: 16),
             
             // Signup link
             TextButton(
               onPressed: () {
                 Navigator.of(context).push(
                   MaterialPageRoute(builder: (_) => const SignupScreen()),
                 );
               },
               child: RichText(
                 text: const TextSpan(
                   text: "New User? ",
                   style: TextStyle(color: AppColors.textSecondary),
                   children: [
                     TextSpan(
                       text: "Create Account",
                       style: TextStyle(
                         color: AppColors.primary,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                   ],
                 ),
               ),
             ),
             
             const SizedBox(height: 32),
           ],
         ),
      ),
    );
  }
  
  Future<void> _handleBiometricLogin() async {
     setState(() => _isLoading = true);
     final bioService = sl<BiometricService>();
     if (await bioService.isAvailable) {
       final authenticated = await bioService.authenticate();
       if (authenticated) {
          _checkOnboardingAndRedirect();
       } else {
         setState(() => _isLoading = false);
       }
     } else {
       setState(() => _isLoading = false);
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text("Biometrics not available on this device")),
       );
     }
  }

  Future<void> _checkOnboardingAndRedirect() async {
    final prefs = await SharedPreferences.getInstance();
    final onboarded = prefs.getBool('onboarding_complete') ?? false;
    
    if (mounted) {
      if (onboarded) {
         Navigator.pushReplacementNamed(context, '/home');
      } else {
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MedicalIntakeScreen()));
      }
    }
  }

  void _handleLogin() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.login(); // Mocks successful login

    if (!mounted) return;

    if (authProvider.status == AuthStatus.authenticated) {
       _checkOnboardingAndRedirect();
    } else if (authProvider.status == AuthStatus.error) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage ?? "Login Failed")),
      );
    }
  }
}
