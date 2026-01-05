import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:neuvox/core/constants/app_colors.dart';
import 'package:neuvox/presentation/widgets/gradient_scaffold.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    
    // TODO: Check actual auth status here
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo / Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.5),
                    blurRadius: 30,
                    spreadRadius: 10,
                  )
                ],
              ),
              child: const Icon(
                Icons.graphic_eq, // Placeholder for Neural/Voice icon
                size: 60,
                color: Colors.white,
              ),
            ).animate()
              .scale(duration: 1.seconds, curve: Curves.easeOutBack)
              .shimmer(delay: 1.seconds, duration: 1500.ms, color: AppColors.accent),

            const SizedBox(height: 40),

            // Title
            const Text(
              "NeuVox",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(duration: 800.ms).moveY(begin: 20, end: 0),

            const SizedBox(height: 16),

            // Tagline
            const Text(
              "Your thoughts. Your voice.",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.textSecondary,
                letterSpacing: 1.2,
              ),
            ).animate()
             .fadeIn(delay: 800.ms, duration: 800.ms)
             // Typewriter effect simulation (basic fade/slide works well too for clean UI)
             .moveY(begin: 10, end: 0),
          ],
        ),
      ),
    );
  }
}
