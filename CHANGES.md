# Changes

## 2026-06-08

- Added `make check` with static project, plist, scheme, screenshot, and
  documentation checks that do not require Xcode.
- Added a small polygon guard so fewer than three touch coordinates do not
  replace the current map overlay.
- Added XCTest coverage for the minimum coordinate rule.
- Replaced generated placeholder XCTest methods and covered negative coordinate
  counts.
- Cleared in-progress polygon coordinates when touch input is cancelled.
- Cleared in-progress polygon coordinates when leaving edit mode.
- Aligned the CocoaPods platform with the Xcode iOS 10.1 deployment target.
- Documented that map coordinates stay local by default and that future export,
  upload, or analytics behavior must be explicit.
- Expanded local ignore rules for environment files, logs, temporary files,
  and Xcode user state.
