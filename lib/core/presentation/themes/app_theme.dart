import 'package:flutter/material.dart';

class AppThemes {
  const AppThemes._();

  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF12715D)),
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }
}
