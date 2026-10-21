# Way33 Mobile — verification and delivery

Updated 21 October 2026. Work is on `feat/mobile-foundation`, in [draft PR #1](https://github.com/wifieg/way33-mobile/pull/1) targeting `develop`. Nothing has been merged or submitted to Apple.

## Employee experience

- Arabic/English onboarding and employee workspace, RTL, bundled Arabic type, system light/dark themes and large-text support.
- Attendance check-in/check-out with duplicate guards, validated leave requests and details, a sample payslip, account, privacy notice and sign-out that clears the session.
- A consistent Way33 visual proposal. Reference screenshots guide section order/navigation; colors and exact shapes remain independent design choices.
- Repeatable host widget previews and native iOS integration captures for progress reviews.

All employee, company, attendance, request and salary data is fictional and held in memory. Company selection checks an HTTPS origin's format only; it does not verify a server or authenticate. No production credentials are collected. `DEMO_MODE=false` hides demo entry without enabling live login. `API_BASE_URL` only provides an initial form value.

## Verified evidence

Results below identify their source revision; an earlier run does not certify later runtime changes. Flutter 3.35.7 / Dart 3.9 were used in GitHub Actions.

| Check / artifact | Evidence |
| --- | --- |
| Static analysis, 22 unit/widget tests | Passed for `210ec6f` (19 formatted Dart files, zero changes): [analysis job](https://github.com/wifieg/way33-mobile/actions/runs/39539292347/job/119023092116). The four capture-only cases are skipped during the normal test run and executed separately. |
| 24 widget previews | Arabic/English, light/dark, six screens per variant: [development renders](https://github.com/wifieg/way33-mobile/actions/runs/39539292347/artifacts/12319435204). These are host Flutter renders, not simulator screenshots. |
| Android debug build | [Demo APK artifact](https://github.com/wifieg/way33-mobile/actions/runs/39539292347/artifacts/12318946728), built successfully for `210ec6f`. This is a development APK, not a signed store release. |
| iOS release archive | [Unsigned archive](https://github.com/wifieg/way33-mobile/actions/runs/39539292347/artifacts/12319440171), built successfully for `210ec6f` with Xcode 26.3 / iOS SDK 26.2. App and bundled SDK privacy manifests were found and parsed. It is not an installable IPA or a signed TestFlight upload. |
| Native iPad flow | Four Arabic/English × light/dark integration cases passed on iPad Pro 13-inch for `210ec6f`; [28 PNG captures](https://github.com/wifieg/way33-mobile/actions/runs/39539292347/artifacts/12318763158), 2064×2752. |
| Native iPhone flow | Four Arabic/English × light/dark integration cases passed on iPhone 16 Pro for `210ec6f`; [28 PNG captures](https://github.com/wifieg/way33-mobile/actions/runs/39539292347/artifacts/12319721346), 1206×2622. |
| Simulator tool | Both device jobs passed with the version-checked, simulator-only backport of official Flutter PR #193142. See [tool workaround](scripts/patches/README.md). [Complete verification run](https://github.com/wifieg/way33-mobile/actions/runs/39539292347) succeeded for `210ec6f`. |

The 56 native PNGs were downloaded and decoded successfully at the dimensions above. Representative Arabic home, salary and account screens were visually reviewed; the navigation snackbar no longer covers salary/account. The two committed host previews exactly match this run's capture output. Final store exports still require review after live integration and approved artwork. Documentation-only commits after `210ec6f` do not change the validated app or capture tool.

GitHub artifact links require repository access and are subject to retention. Inspect images before using them in store metadata. Captures show a development demo, not a live ERP service.

Local Flutter builds were unavailable because this workspace has no Flutter SDK and its network proxy rejects the official SDK download host. The build/test results above came from GitHub-hosted Linux/macOS runners. No physical iPhone/iPad/Android testing or Huawei compatibility evaluation has been performed.

## Remaining release work

Live authentication, tenant discovery, attendance policies, leave approval and employee-only payroll endpoints must be implemented and validated before replacing the demo repository. The current repository has no validated production mobile API connection.

Apple Developer enrollment acceptance, final Bundle ID/Team ID, distribution signing, App Store Connect record, approved icon, published privacy/support URLs, accurate live-data privacy answers, review access and physical-device checks remain outstanding. See the [Apple checklist and primary sources](docs/APPLE_READINESS.md).

## Run and capture

```sh
flutter pub get
flutter analyze
flutter test
flutter run --dart-define=DEMO_MODE=true
flutter test test/preview_capture_test.dart --dart-define=CAPTURE_PREVIEWS=true
```

Never commit production secrets or customer data.
