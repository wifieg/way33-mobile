import 'package:flutter/material.dart';

class AppTheme {
  static const navy = Color(0xFF143D68);
  static const blue = Color(0xFF1F67B1);
  static const green = Color(0xFF20A47B);
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(seedColor: blue, primary: blue, secondary: green);
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: const Color(0xFFF6F8FC),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF6F8FC), centerTitle: false),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDCE4F0))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
        backgroundColor: blue, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      )),
      cardTheme: CardThemeData(color: Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
    );
  }
}
