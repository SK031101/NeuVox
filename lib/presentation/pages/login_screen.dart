import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:neuvox/core/constants/app_colors.dart';
import 'package:neuvox/presentation/widgets/gradient_scaffold.dart';
import 'home_screen.dart'; // We'll create this next

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _handleLogin() async {
    setState(() => _isLoading = true);
    
    // Simulate Auth Service Call
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Navigate to Home
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
             
             // Microsoft Login Button
             _buildMicrosoftLoginButton(),
             
             const SizedBox(height: 16),
             
             // Signup link
             TextButton(
               onPressed: () {},
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

  Widget _buildMicrosoftLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white, // Microsoft white
        foregroundColor: Colors.black, // Text black
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: _isLoading 
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
                  runSpacing: 2,
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
}
