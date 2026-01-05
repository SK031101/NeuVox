import 'package:flutter/material.dart';

class AppColors {
  // Primary: Intelligence / AI
  static const Color primary = Color(0xFF6A00FF);
  
  // Accent: Speech / Action
  static const Color accent = Color(0xFFFF7A00);
  
  // Backgrounds
  static const Color backgroundDark = Color(0xFF0F0F1A); // Deep purple/black
  static const Color backgroundLight = Color(0xFF1A1A2E); // Slightly lighter
  
  // Functional
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C0);
  static const Color success = Color(0xFF00E676);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFC107);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF6A00FF),
      Color(0xFF4A00B3),
    ],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1A1A2E), // Light
      Color(0xFF0F0F1A), // Dark
    ],
  );
}
