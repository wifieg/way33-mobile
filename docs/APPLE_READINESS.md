# Apple preparation — 21 October 2026

Distribution requested: TestFlight, then public App Store. The owner reports an individual Apple Developer enrollment request awaiting acceptance. Account activation, signing and App Store submission are not part of the completed build checks.

## Implemented preparation

- Arabic/English native localization declarations, bundled OFL-licensed Arabic typography, RTL, system light/dark themes and scalable layouts.
- A privacy notice reachable before demo entry and from the employee account. It describes this offline, session-only demo; it is not a policy for a live ERP service.
- An app `PrivacyInfo.xcprivacy` included in the Runner Resources phase. It declares no tracking or data collection for the current demo. SDK privacy manifests must also be present in the built app; the iOS CI job checks the bundle.
- App Transport Security retains HTTPS restrictions. The export-compliance flag declares no non-exempt encryption for current standard transport/platform cryptography; reassess if custom cryptography is introduced.
- CI uses macOS and Xcode 26, verifies iOS SDK >=26, and builds an **unsigned** iOS release archive. Independent iPhone/iPad jobs are configured to run the actual app's demo flow and capture screenshots; job configuration alone is not proof that both devices passed.
- Widget previews are development renders. Native simulator screenshots are separately labeled. Neither set represents a production ERP connection or physical-device certification.

Verified so far: Xcode 26.3 / iOS SDK 26.2 release archive, bundled app/SDK privacy manifests, 22 unit/widget tests, 24 host previews and an earlier native iPhone flow with 28 screenshots. Simulator startup has exceeded the original 10-minute limit on some runners; the latest workflow gives each device its own runner and 20-minute capture step. See [revision-specific results](../UPLOAD_STATUS.md) for status and artifacts. This is preparation for submission, not confirmation of Apple compliance or approval.

## Before signing or submission

| Item | Status / required evidence |
| --- | --- |
| Developer membership | Enrollment acceptance pending; do not attempt TestFlight upload before activation. |
| Publisher identity | An individual account displays the owner's legal name. Review guideline 5.1.1(ix) with Apple before handling sensitive employee/payroll data: it calls for the legal entity providing services in applicable cases. Individual-account acceptance is not guaranteed. |
| Bundle ID / Team ID | Confirm ownership and register the final identifier in the active account. `com.way33.wayErpMobile` remains a development identifier. |
| Signing | Distribution certificate/provisioning and App Store Connect app record are not configured. An unsigned `.xcarchive` is not an installable IPA and cannot be uploaded as a signed release. |
| App completeness | Live authentication, tenant verification, attendance rules, leave workflows and employee-only payroll endpoints are not implemented. Do not submit this demo as a completed live service. |
| Review access | Supply a working review account/service and accurate review notes once the live app is complete. A demo must reflect the actual functionality, not substitute for missing services. |
| Published privacy/support | Owner identity, public privacy-policy URL, support URL/contact, retention and deletion procedure are still required. Update the in-app notice and App Store privacy answers for live data and all SDKs. |
| Deletion / authentication | No account creation or social login exists today. Reassess account-deletion and login requirements if those features are added. |
| Artwork | Replace Flutter launcher artwork with approved Way33 assets; keep the 1024px App Store icon opaque. |
| Screenshots | Use accepted, current App Store Connect display slots. Target iPhone 16 Pro (1206×2622) and iPad Pro 13-inch (2064×2752), Arabic/English, from the real running app. Regenerate after any UI/data change, verify opaque PNG/JPEG exports and exclude host development renders from final store metadata. |
| Store metadata | Confirm localized name/description/category, current age-rating questionnaire, distribution countries and applicable agreements/compliance. |
| Device testing | Test on physical iPhone/iPad, including VoiceOver, large text, offline/error handling and real sign-in/out before submitting. Simulator/build success is not Apple approval. |

## Current Apple sources

Reviewed on 21 October 2026; recheck immediately before upload.

- [Upcoming requirements](https://developer.apple.com/news/upcoming-requirements/): since 28 April 2026, Xcode 26 / iOS 26 SDK or later. SDK version is different from the minimum supported device OS; the project currently targets iOS 13.
- [Review guidelines](https://developer.apple.com/app-store/review/guidelines/): completeness, privacy policy, sensitive-data publisher identity, review access, and conditional account-deletion/login rules.
- [Enrollment and individual publisher identity](https://developer.apple.com/help/account/membership/program-enrollment).
- [Privacy manifest files](https://developer.apple.com/documentation/bundleresources/privacy-manifest-files) and [required reason API entries](https://developer.apple.com/documentation/technotes/tn3183-adding-required-reason-api-entries-to-your-privacy-manifest).
- [Screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/).
- [Flutter iOS release guide](https://docs.flutter.dev/deployment/ios).

## Repeatable image captures

```sh
flutter test test/preview_capture_test.dart --dart-define=CAPTURE_PREVIEWS=true
flutter drive --driver=test_driver/preview_driver.dart \
  --target=integration_test/employee_preview_test.dart \
  -d <simulator-id> --dart-define=DEMO_MODE=true \
  --dart-define=SCREENSHOT_DEVICE=iphone
```

CI uploads widget previews and native simulator captures separately so future progress updates can show the actual changed screens. Pictures must be inspected for missing fonts/icons, clipping, keyboard overlays and inconsistent localization before sharing.
