import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import 'signup_screen.dart';
import '../home/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  Future<void> _handleMicrosoftSignIn() async {
    HapticFeedback.mediumImpact();
    
    setState(() => _isLoading = true);
    
    await Future.delayed(const Duration(seconds: 2));
    
    final bool isExistingUser = DateTime.now().millisecond % 2 == 0;
    
    setState(() => _isLoading = false);
    
    if (!mounted) return;
    
    if (isExistingUser) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SignupScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.xxl),
                
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryPurple,
                              AppColors.primaryOrange,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.record_voice_over_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.md),
                      const Text(
                        'NeuVox',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neutral900,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 20,
                          color: AppColors.neutral700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 60),
                
                Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                    border: Border.all(
                      color: AppColors.info.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.accessibility_new_rounded,
                        color: AppColors.info,
                        size: 24,
                      ),
                      const SizedBox(width: AppDimensions.md),
                      const Expanded(
                        child: Text(
                          'Designed with accessibility in mind. Screen reader optimized.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.neutral700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppDimensions.xl),
                
                SizedBox(
                  height: AppDimensions.minTapTarget,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleMicrosoftSignIn,
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Icon(
                                  Icons.window,
                                  size: 16,
                                  color: AppColors.primaryPurple,
                                ),
                              ),
                              const SizedBox(width: AppDimensions.sm),
                              const Text(
                                'Sign in with Microsoft',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                
                const SizedBox(height: AppDimensions.md),
                
                const Text(
                  'Use your Microsoft account to securely access NeuVox',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.neutral500,
                  ),
                ),
                
                const SizedBox(height: AppDimensions.xxl),
                
                _buildFeatureItem(
                  Icons.security_rounded,
                  'Secure Authentication',
                  'Enterprise-grade security with Microsoft Entra ID',
                ),
                const SizedBox(height: AppDimensions.lg),
                _buildFeatureItem(
                  Icons.cloud_sync_rounded,
                  'Cloud Sync',
                  'Your data synced across all devices',
                ),
                const SizedBox(height: AppDimensions.lg),
                _buildFeatureItem(
                  Icons.verified_user_rounded,
                  'Privacy First',
                  'HIPAA-compliant data protection',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primaryPurple,
            size: 24,
          ),
        ),
        const SizedBox(width: AppDimensions.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}