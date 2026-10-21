import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  final directory = Directory('artifacts/ios-simulator-screenshots')
    ..createSync(recursive: true);
  await integrationDriver(
    onScreenshot: (name, bytes, [arguments]) async {
      await File('${directory.path}/$name.png').writeAsBytes(bytes);
      return true;
    },
  );
}
