# Changes

## 2026-06-13

- Added a structural guard for credential-free signing metadata that rejects
  Apple development teams, provisioning profiles, entitlements paths, and
  account-specific signing identities.

## 2026-06-09

- Added an explicit start-draft helper and test so new polygon drafts clear
  stale coordinates before collecting touches.
- Made cancelled touch callbacks clear stale polygon drafts even when edit mode
  has already changed.
- Added stable Make aliases for lint, test, build, verify, and check gates.
- Added static plist bundle identifier and package type checks for framework
  and XCTest target metadata.

## 2026-06-10

- Added pinned, read-only hosted macOS structural validation for the legacy
  MapKit/CocoaPods project.
- Guarded map view delegate outlet setup so unconnected scaffold instances do
  not force-touch the `mapView` outlet.
- Guarded the touch input map outlet and cleared partial polygon drafts when the
  map is unavailable.

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
- Cleared finalized polygon draft coordinates after invalid and successful
  touch-end handling.
- Aligned the CocoaPods platform with the Xcode iOS 10.1 deployment target.
- Documented that map coordinates stay local by default and that future export,
  upload, or analytics behavior must be explicit.
- Expanded local ignore rules for environment files, logs, temporary files,
  and Xcode user state.
