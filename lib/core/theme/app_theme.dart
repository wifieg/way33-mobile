import 'package:flutter/material.dart';

class AppTheme {
  static const navy = Color(0xFF124D49);
  static const blue = Color(0xFF2463B6);
  static const green = Color(0xFF087F73);
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final canvas = dark ? const Color(0xFF0D1724) : const Color(0xFFF3F6FA);
    final surface = dark ? const Color(0xFF172435) : Colors.white;
    final line = dark ? const Color(0xFF2A3A4E) : const Color(0xFFE3EAF2);
    final scheme = ColorScheme.fromSeed(
      seedColor: green,
      brightness: brightness,
    ).copyWith(
      surface: surface,
      onSurface: dark ? const Color(0xFFF0F5FA) : const Color(0xFF182D42),
      onSurfaceVariant:
          dark ? const Color(0xFFB5C3D3) : const Color(0xFF607487),
      outlineVariant: line,
    );
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'Way33Sans',
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      appBarTheme: AppBarTheme(
        backgroundColor: canvas,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 72,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: line)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorMaxLines: 3,
        helperMaxLines: 3,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: green,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(54),
        elevation: 0,
        shadowColor: Colors.transparent,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      )),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        foregroundColor: scheme.onSurface,
        side: BorderSide(color: line),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      )),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
      )),
      cardTheme: CardThemeData(
          color: surface,
          margin: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: line))),
      dividerTheme: DividerThemeData(color: line, thickness: 1, space: 24),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 80,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
              fontFamily: 'Way33Sans',
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w500,
              color: states.contains(WidgetState.selected)
                  ? scheme.primary
                  : scheme.onSurfaceVariant,
            )),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: navy,
        contentTextStyle:
            const TextStyle(color: Colors.white, fontFamily: 'Way33Sans'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
    return base.copyWith(
        textTheme: base.textTheme.copyWith(
      headlineLarge: base.textTheme.headlineLarge
          ?.copyWith(fontSize: 38, fontWeight: FontWeight.w700),
      headlineMedium: base.textTheme.headlineMedium
          ?.copyWith(fontSize: 30, fontWeight: FontWeight.w700),
      headlineSmall: base.textTheme.headlineSmall
          ?.copyWith(fontSize: 26, fontWeight: FontWeight.w700),
      titleLarge: base.textTheme.titleLarge
          ?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
      titleMedium: base.textTheme.titleMedium
          ?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: base.textTheme.bodyLarge?.copyWith(fontSize: 16, height: 1.6),
      bodyMedium:
          base.textTheme.bodyMedium?.copyWith(fontSize: 14, height: 1.6),
      bodySmall: base.textTheme.bodySmall?.copyWith(fontSize: 12, height: 1.5),
      labelLarge: base.textTheme.labelLarge
          ?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
    ));
  }
}
