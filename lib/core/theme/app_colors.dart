// lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Deep Navy - Primary background and UI elements
  static const deepNavy = Color(0xFF1A2332);
  static const deepNavyLight = Color(0xFF2A3442);

  // Sky Blue - Interactive elements and accents
  static const skyBlue = Color(0xFF4A9EFF);
  static const skyBlueLight = Color(0xFF6BB1FF);

  // Vibrant Orange - Active states and highlights
  static const vibrantOrange = Color(0xFFFF6B35);
  static const vibrantOrangeLight = Color(0xFFFF8555);

  // Golden Yellow - Success and completion states
  static const goldenYellow = Color(0xFFFFB800);
  static const goldenYellowLight = Color(0xFFFFC933);

  // Neutral tones
  static const white = Color(0xFFFFFFFF);
  static const lightGrey = Color(0xFFE5E5E5);
  static const mediumGrey = Color(0xFF9E9E9E);
  static const darkGrey = Color(0xFF424242);

  // Semantic colors used by the app themes.
  static const darkBackground = deepNavy;
  static const darkSurface = deepNavyLight;
  static const darkCard = Color(0xFF222C3A);
  static const darkPrimary = skyBlue;
  static const darkOnPrimary = deepNavy;
  static const darkOnSurface = white;
  static const darkOnSurfaceVariant = Color(0xFFB8C1CC);
  static const darkDivider = Color(0xFF344054);

  static const lightBackground = Color(0xFFF6F8FB);
  static const lightSurface = white;
  static const lightCard = white;
  static const lightPrimary = skyBlue;
  static const lightOnPrimary = white;
  static const lightOnSurface = Color(0xFF202733);
  static const lightOnSurfaceVariant = Color(0xFF667085);
  static const lightDivider = Color(0xFFD8DEE8);

  static const error = Color(0xFFE5484D);
}
