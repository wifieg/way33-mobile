import 'package:flutter/material.dart';

class AppTheme {
  static const navy = Color(0xFF143D68);
  static const blue = Color(0xFF1F67B1);
  static const green = Color(0xFF20A47B);
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: blue,
      brightness: brightness,
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Way33Sans',
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme:
          AppBarTheme(backgroundColor: scheme.surface, centerTitle: false),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFDCE4F0))),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      )),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      )),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
      )),
      cardTheme: CardThemeData(
          color: scheme.surfaceContainerLowest,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
    );
  }
}
