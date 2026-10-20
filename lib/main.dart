import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/company_screen.dart';

void main() => runApp(const WayErpApp());

class WayErpApp extends StatefulWidget {
  final Locale initialLocale;
  final ThemeMode themeMode;

  const WayErpApp({
    super.key,
    this.initialLocale = const Locale('ar'),
    this.themeMode = ThemeMode.system,
  });
  @override
  State<WayErpApp> createState() => _WayErpAppState();
}

class _WayErpAppState extends State<WayErpApp> {
  late Locale locale = widget.initialLocale;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Way ERP', debugShowCheckedModeBanner: false,
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    themeMode: widget.themeMode,
    locale: locale,
    supportedLocales: const [Locale('ar'), Locale('en')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    home: CompanyScreen(
      locale: locale,
      onToggleLanguage: () => setState(() => locale = locale.languageCode == 'ar' ? const Locale('en') : const Locale('ar')),
    ),
  );
}
