"""Backport Flutter's simulator log-readiness fix to the pinned capture tool.

Upstream: flutter/flutter#193142, c3ed85ef987759ee54a6bce275490cde2a238dc1.
Only the ephemeral simulator job uses this; engine/app sources are unchanged.
"""
import hashlib
import os
from pathlib import Path
import subprocess


original_sha = "c4d732aec23d8998a57be9450bdd6a4409979bc14538729b3ae1fde8a5c91d75"
patched_sha = "a6487a1417c6644024c647a05b3b322c754baf89ba7ee56fe4eba672a36febb7"
root = Path(os.environ["FLUTTER_ROOT"]).resolve()
source = root / "packages/flutter_tools/lib/src/ios/simulators.dart"
digest = hashlib.sha256(source.read_bytes()).hexdigest()
if digest == patched_sha:
    print("Flutter simulator log-readiness fix already applied")
elif digest == original_sha:
    patch = Path(__file__).resolve().parent / "patches/flutter-3.35.7-ios-log-readiness.patch"
    subprocess.run(["git", "apply", "--check", str(patch)], cwd=root, check=True)
    subprocess.run(["git", "apply", str(patch)], cwd=root, check=True)
    if hashlib.sha256(source.read_bytes()).hexdigest() != patched_sha:
        raise SystemExit("Unexpected patched Flutter tool contents")
    print("Applied simulator-only backport of Flutter PR #193142 to Flutter 3.35.7")
else:
    raise SystemExit("Unsupported Flutter tool source; review/remove the backport after SDK upgrades")

# Force Flutter to rebuild its command-line tool snapshot from the reviewed patch.
for name in ("flutter_tools.snapshot", "flutter_tools.stamp"):
    (root / "bin/cache" / name).unlink(missing_ok=True)
