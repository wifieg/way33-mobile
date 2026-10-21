import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:way_erp_mobile/main.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  for (final language in ['ar', 'en']) {
    for (final dark in [false, true]) {
      testWidgets('iOS employee preview $language ${dark ? 'dark' : 'light'}',
          (tester) async {
        final arabic = language == 'ar';
        const device = String.fromEnvironment('SCREENSHOT_DEVICE', defaultValue: 'iphone');
        final prefix = '$device-$language-${dark ? 'dark' : 'light'}';
        await tester.pumpWidget(WayErpApp(
          key: UniqueKey(),
          initialLocale: Locale(language),
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,
        ));
        await tester.pumpAndSettle();

        Future<void> capture(String name) async {
          expect(tester.takeException(), isNull);
          await binding.takeScreenshot('$prefix-$name');
        }

        Future<void> tap(Finder finder) async {
          await tester.ensureVisible(finder);
          await tester.tap(finder);
          await tester.pumpAndSettle();
        }

        await capture('company');
        await tap(find.text(arabic ? 'استكشاف النسخة التجريبية' : 'Explore demo'));
        await tap(find.text(arabic ? 'دخول الحساب التجريبي' : 'Enter demo account'));
        await capture('home');
        await tap(find.text(arabic ? 'طلباتي' : 'Requests'));
        await capture('requests');
        await tap(find.text(arabic ? 'طلب إجازة تجريبي' : 'Demo leave request'));
        await capture('leave-form');
        await tester.enterText(find.byKey(const Key('leave-days')), '3');
        await tester.enterText(find.byKey(const Key('leave-reason')),
            arabic ? 'زيارة عائلية' : 'Family visit');
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tap(find.text(arabic ? 'حفظ الطلب التجريبي' : 'Save demo request'));
        expect(find.textContaining('DEMO-1'), findsOneWidget);
        await tap(find.text(arabic ? 'الراتب' : 'Salary'));
        await capture('salary');
        await tap(find.text(arabic ? 'حسابي' : 'Account'));
        await capture('account');
        await tap(find.text(arabic ? 'الخصوصية' : 'Privacy'));
        expect(find.text(arabic ? 'خصوصية النسخة التجريبية' : 'Demo privacy notice'),
            findsOneWidget);
        await capture('privacy');
      });
    }
  }
}
