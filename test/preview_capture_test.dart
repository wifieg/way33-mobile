import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:way_erp_mobile/main.dart';

void main() {
  const captureEnabled = bool.fromEnvironment('CAPTURE_PREVIEWS');

  for (final language in ['ar', 'en']) {
    for (final dark in [false, true]) {
      testWidgets('capture $language ${dark ? 'dark' : 'light'} previews',
          (tester) async {
        final loader = FontLoader('Way33Sans')
          ..addFont(rootBundle.load('assets/fonts/NotoSansArabic.ttf'));
        await loader.load();
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        addTearDown(() => debugDefaultTargetPlatformOverride = null);
        tester.view.physicalSize = const Size(1320, 2868);
        tester.view.devicePixelRatio = 3;
        tester.view.padding = const FakeViewPadding(top: 186, bottom: 102);
        tester.view.viewPadding = const FakeViewPadding(top: 186, bottom: 102);
        addTearDown(tester.view.reset);

        final root = GlobalKey();
        final prefix = '$language-${dark ? 'dark' : 'light'}';
        final arabic = language == 'ar';
        await tester.pumpWidget(RepaintBoundary(
          key: root,
          child: WayErpApp(
            key: UniqueKey(),
            initialLocale: Locale(language),
            themeMode: dark ? ThemeMode.dark : ThemeMode.light,
          ),
        ));
        await tester.pumpAndSettle();

        Future<void> capture(String name) async {
          expect(tester.takeException(), isNull);
          final boundary = root.currentContext!.findRenderObject()!
              as RenderRepaintBoundary;
          await tester.runAsync(() async {
            final image = await boundary.toImage(pixelRatio: 3);
            final data = await image.toByteData(format: ui.ImageByteFormat.png);
            final directory = Directory('artifacts/widget-previews')
              ..createSync(recursive: true);
            await File('${directory.path}/$prefix-$name.png')
                .writeAsBytes(data!.buffer.asUint8List());
            image.dispose();
          });
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
        await tester.pageBack();
        await tester.pumpAndSettle();
        await tap(find.text(arabic ? 'الراتب' : 'Salary'));
        await capture('salary');
        await tap(find.text(arabic ? 'حسابي' : 'Account'));
        await capture('account');
      }, skip: !captureEnabled);
    }
  }
}
