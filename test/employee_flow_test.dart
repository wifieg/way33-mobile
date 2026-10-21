import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:way_erp_mobile/main.dart';

Future<void> enterDemo(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Explore demo'));
  await tester.tap(find.text('Explore demo'));
  await tester.pumpAndSettle();
  await tester.ensureVisible(find.text('Enter demo account'));
  await tester.tap(find.text('Enter demo account'));
  await tester.pumpAndSettle();
}

Future<void> tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Arabic is the default and language switches to English',
      (tester) async {
    await tester.pumpWidget(const WayErpApp());
    expect(find.text('رابط الشركة'), findsOneWidget);
    expect(
        Directionality.of(
            tester.element(find.byKey(const Key('company-domain')))),
        TextDirection.rtl);
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(find.text('Company domain'), findsOneWidget);
  });

  testWidgets('live company selection never asks for unsupported credentials',
      (tester) async {
    await tester.pumpWidget(const WayErpApp(initialLocale: Locale('en')));
    await tapVisible(tester, find.text('Continue'));
    expect(
        find.text('Enter a valid company domain using HTTPS.'), findsOneWidget);
    await tester.enterText(
        find.byKey(const Key('company-domain')), 'acme.example.com');
    await tapVisible(tester, find.text('Continue'));
    expect(find.text('Company domain selected'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    expect(find.textContaining('has not been verified'), findsOneWidget);
  });

  testWidgets(
      'employee can try attendance, request leave, inspect salary and sign out',
      (tester) async {
    await tester.pumpWidget(const WayErpApp(initialLocale: Locale('en')));
    await enterDemo(tester);

    expect(
        tester
            .widget<OutlinedButton>(find.byKey(const Key('check-out')))
            .onPressed,
        isNull);
    await tapVisible(tester, find.byKey(const Key('check-in')));
    expect(
        tester
            .widget<ElevatedButton>(find.byKey(const Key('check-in')))
            .onPressed,
        isNull);
    expect(
        tester
            .widget<OutlinedButton>(find.byKey(const Key('check-out')))
            .onPressed,
        isNotNull);
    await tapVisible(tester, find.byKey(const Key('check-out')));
    expect(
        tester
            .widget<OutlinedButton>(find.byKey(const Key('check-out')))
            .onPressed,
        isNull);

    await tester.tap(find.text('Requests'));
    await tester.pumpAndSettle();
    expect(find.text('No requests yet'), findsOneWidget);
    await tester.tap(find.text('Demo leave request'));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.text('Save demo request'));
    expect(find.text('Enter a number from 1 to 21.'), findsOneWidget);
    expect(find.text('Enter a reason for leave.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('leave-days')), '3');
    await tester.enterText(
        find.byKey(const Key('leave-reason')), 'Family visit');
    await tapVisible(tester, find.text('Save demo request'));
    expect(find.text('Leave · 3 days'), findsOneWidget);
    await tester.tap(find.text('Leave · 3 days'));
    await tester.pumpAndSettle();
    expect(find.text('Family visit'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Salary'));
    await tester.pumpAndSettle();
    expect(find.text('7,500.00'), findsOneWidget);
    expect(find.text('7,000.00'), findsNWidgets(2));

    await tester.tap(find.text('Account'));
    await tester.pumpAndSettle();
    await tapVisible(tester, find.byKey(const Key('sign-out')));
    expect(find.text('Company domain'), findsOneWidget);
    await enterDemo(tester);
    expect(
        tester
            .widget<ElevatedButton>(find.byKey(const Key('check-in')))
            .onPressed,
        isNotNull);
    await tester.tap(find.text('Requests'));
    await tester.pumpAndSettle();
    expect(find.text('No requests yet'), findsOneWidget);
  });

  for (final locale in [const Locale('ar'), const Locale('en')]) {
    for (final theme in [ThemeMode.light, ThemeMode.dark]) {
      testWidgets('phone layout supports $locale, $theme and large text',
          (tester) async {
        tester.view.physicalSize = const Size(390, 844);
        tester.view.devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 1.5;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        await tester
            .pumpWidget(WayErpApp(initialLocale: locale, themeMode: theme));
        await tapVisible(
            tester,
            find.text(locale.languageCode == 'ar'
                ? 'استكشاف النسخة التجريبية'
                : 'Explore demo'));
        await tapVisible(
            tester,
            find.text(locale.languageCode == 'ar'
                ? 'دخول الحساب التجريبي'
                : 'Enter demo account'));
        expect(tester.takeException(), isNull);
        for (final icon in [
          Icons.description_outlined,
          Icons.payments_outlined,
          Icons.person_outline
        ]) {
          await tester.tap(find.descendant(
              of: find.byType(NavigationBar), matching: find.byIcon(icon)));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      });
    }
  }
}
