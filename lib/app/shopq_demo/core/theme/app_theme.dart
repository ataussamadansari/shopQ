import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const _green = Color(0xFF15803D);
  static const _blue = Color(0xFF1D4ED8);

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _green,
      brightness: Brightness.light,
      primary: _green,
      secondary: _blue,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _green, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        selectedColor: _green.withOpacity(0.14),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.black,
          letterSpacing: -0.3,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF334155),
          height: 1.35,
        ),
      ),
    );
  }
}
