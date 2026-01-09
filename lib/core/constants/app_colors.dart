import 'package:flutter/material.dart';

class AppColors {
  // Primary: Intelligence / AI
  static const Color primary = Color(0xFF6A00FF);
  
  // Accent: Speech / Action
  static const Color accent = Color(0xFFFF7A00);
  
  // Backgrounds
  // Medical Standard Dark Mode (High Contrast, Neutral)
  static const Color backgroundDark = Color(0xFF121212); // Pure Monitor Black
  static const Color backgroundLight = Color(0xFF1E1E1E); // Surface Grey
  
  // Functional
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB3B3B3); // Neutral Grey
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFCF6679);
  static const Color warning = Color(0xFFFFB74D);
  
  // Gradients (Subtle, professional)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6A00FF),
      Color(0xFF5300C7),
    ],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF121212),
      Color(0xFF121212), // Solid for clinical clarity
    ],
  );
}
