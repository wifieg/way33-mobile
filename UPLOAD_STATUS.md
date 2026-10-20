# Way ERP Mobile - upload status

The Flutter source now includes company selection, a demo entry screen and an Arabic/English employee workspace (attendance, leave requests, a sample payslip and account/sign-out). The demo repository is session-only and never connects to a company. Live company selection validates a domain only; it does not authenticate or verify a server.

Included: light/dark themes, request validation and details, duplicate attendance guards, repository tests, company-domain tests, bilingual widget flow/layout tests and a GitHub Actions analysis/test job using Flutter 3.35.7.

Local Flutter analysis, widget tests and device builds have NOT been executed: the workspace has no Flutter SDK and its network proxy rejects the official SDK download host (`storage.googleapis.com`, HTTP 403). The workflow has been added but has not been run. Do not treat these sources as a certified device build.

No live Django mobile API, production authentication, or device build has been validated. Android and iOS platform folders must be generated with the official Flutter SDK, then tested.

On a machine with Flutter 3.35.7:

```sh
flutter pub get
flutter analyze
flutter test
flutter create --empty --platforms=android,ios --project-name way_erp_mobile --org com.way33 .
flutter run --dart-define=DEMO_MODE=true
```

Live authentication, tenant discovery, attendance policies, leave approval and employee-only payroll endpoints must be agreed and implemented in the ERP before replacing the demo repository. No production credentials should be collected by this starter. `DEMO_MODE=false` hides demo entry; it does not enable live login. `API_BASE_URL`, if supplied, is currently only an initial company-origin form value, not a working API connection. Huawei compatibility has not been evaluated.

Never commit production secrets or customer data.
