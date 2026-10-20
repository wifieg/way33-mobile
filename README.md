# Way ERP Mobile

Flutter mobile app for Way ERP (Android, iOS, and Huawei compatibility evaluation).

Employee demo: Arabic/English company selection, attendance, leave requests, a sample payslip and account/sign-out. Supports RTL, system light/dark themes and large text. All demo data is fictional, stays in memory and is cleared on sign-out.

Use Flutter 3.35.7 (Dart 3.9) or a compatible newer SDK:

```sh
flutter pub get
flutter analyze
flutter test
flutter run --dart-define=DEMO_MODE=true
```

Android and iOS project files were generated with the official Flutter tool. GitHub Actions checks formatting, analyzes and tests the app, then builds an Android debug demo APK. iOS builds require macOS/Xcode; iOS and Huawei device compatibility have not been validated.

Live ERP login and data synchronization are not implemented. Entering a company domain only validates its format; the app does not collect passwords or verify company connectivity. `DEMO_MODE=false` hides demo entry and does not enable live login. `API_BASE_URL` currently only supplies the initial company-origin form value. See [upload status](UPLOAD_STATUS.md) for validation details and remaining integration work.

Development in progress. Generated application IDs, default launcher artwork and debug signing are development settings. Do not commit secrets or customer data.
