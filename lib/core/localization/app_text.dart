import 'package:flutter/widgets.dart';

extension AppText on BuildContext {
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';

  String text(String arabic, String english) => isArabic ? arabic : english;
}
