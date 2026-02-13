import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors (Both modes)
  static const Color primary = Color(0xFF6273f9);
  static const Color primaryDark = Color(0xff515ecd);
  static const Color primaryLight = Color(0xFF6273f9);
  static const Color secondary = Color(0xFF84ec6f);
  static const Color secondaryDark = Color(0xff5ba84b);
  static const Color secondaryLight = Color(0xFF84ec6f);

  // Neutral Colors (Both modes)
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFF616161);

  // Light Mode Colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Color(0xFFF8F9FA);
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textDisabledLight = Color(0xFF9E9E9E);
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color errorLight = Color(0xFFF44336);

  // Dark Mode Colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textDisabledDark = Color(0xFF757575);
  static const Color borderDark = Color(0xFF424242);
  static const Color errorDark = Color(0xFFCF6679);


  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF212121);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFF9E9E9E);

  // Border Colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderFocus = Color(0xFF0066FF);

  // Shadow Colors
  static const Color shadow = Color(0x1A000000);


  // Gradient Colors
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0XFF02E2FE)],
  );

  static const Gradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, Color(0XFF02E2FE)],
  );

  static const lightCard100 = Color(0x40DBDBDB);
  static const darkCard100 = Color(0x40A9A9A9);
}
