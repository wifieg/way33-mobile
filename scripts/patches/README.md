# Temporary iOS simulator tool backport

Flutter 3.35.7 can launch a simulator app before its log reader is ready, missing the VM service URL and hanging before any integration case executes. The observed CI logs show `simctl launch` before `simctl spawn … log stream`, matching [Flutter issue #181771](https://github.com/flutter/flutter/issues/181771).

`flutter-3.35.7-ios-log-readiness.patch` adapts the simulator-only fix from [Flutter PR #193142](https://github.com/flutter/flutter/pull/193142), merged as `c3ed85ef987759ee54a6bce275490cde2a238dc1` on 15 October 2026. It waits for the first log-stream line before launching the app, resets readiness on each subscription, and completes it when the process exits. Changes from upstream are limited to the older UTF-8 stream API, nearby source structure and shorter comments.

`prepare_ios_capture_tool.py` checks the original and patched SHA-256 hashes, fails on an unknown SDK source, applies the checked-in patch and invalidates only the tool snapshot. Simulator jobs disable SDK caching so the modified command-line tool is not shared with other jobs. Flutter engine/framework, app source, release builds and privacy declarations are unchanged. This is a build-tool workaround, not a claim that a newer Flutter release was tested.

Remove the backport after choosing and validating an official stable Flutter release containing the fix. A longer timeout alone does not recover a missed log event. Upstream code is covered by [Flutter's BSD license](FLUTTER_LICENSE).
