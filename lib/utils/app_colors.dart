import 'package:flutter/material.dart';

/// App color palette matching the Quizzical Figma design.
class AppColors {
  AppColors._();

  // Primary Theme Colors (Deep Teal as requested)
  static const Color primary = Color(0xFF006F6A);
  static const Color primaryDark = Color(0xFF004D49);
  static const Color primaryLight = Color(0xFFE6F4F3);
  static const Color primaryAccent = Color(0xFF00897B);

  // Background and Surface
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Colors.white;
  static const Color cardShadow = Color(0x0D000000);

  // Typography
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Sliders and Active accents
  static const Color sliderActive = Color(0xFF0080FF);
  static const Color sliderInactive = Color(0xFFE2E8F0);

  // Answer state colors (Matching Figma screenshots)
  static const Color answerNeutralBg = Colors.white;
  static const Color answerNeutralBorder = Color(0xFFE2E8F0);

  // Correct answer (Soft green card with deep green icon)
  static const Color answerCorrectBg = Color(0xFFA3D9C9);
  static const Color answerCorrectBorder = Color(0xFF34D399);
  static const Color answerCorrectIcon = Color(0xFF065F46);
  static const Color answerCorrectText = Color(0xFF064E3B);

  // Incorrect answer (Soft red/pink card with deep red icon)
  static const Color answerIncorrectBg = Color(0xFFFFA4A4);
  static const Color answerIncorrectBorder = Color(0xFFF87171);
  static const Color answerIncorrectIcon = Color(0xFFDC2626);
  static const Color answerIncorrectText = Color(0xFF7F1D1D);

  // Score badge backgrounds
  static const Color scoreGreenBg = Color(0xFF86EFAC);
  static const Color scoreGreenText = Color(0xFF065F46);
  static const Color scoreRedBg = Color(0xFFF87171);
  static const Color scoreRedText = Colors.white;

  // Category Pastel Backgrounds
  static const Color pastelBlue = Color(0xFFDCE7FE);
  static const Color pastelGreen = Color(0xFFDCFCE7);
  static const Color pastelYellow = Color(0xFFFEF3C7);
  static const Color pastelPurple = Color(0xFFEDE9FE);
  static const Color pastelPink = Color(0xFFFFE4E6);
  static const Color pastelOrange = Color(0xFFFFEDD5);
  static const Color pastelTeal = Color(0xFFCCFBF1);
  static const Color pastelIndigo = Color(0xFFE0E7FF);
}
