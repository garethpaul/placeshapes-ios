# PlaceShapes iOS Baseline Plan

status: completed

## Context

`placeshapes-ios` is a Swift 3 MapKit framework sample. It collects touch
coordinates while the controller is in edit mode, then renders those points as
an `MKPolygon` overlay.

## Risks

- Drawing a polygon with fewer than three points creates a degenerate overlay
  and makes the interaction contract unclear.
- The sample handles map coordinates, which can represent private places.
- Local verification depended on Xcode being available in the environment.
- Xcode user state, logs, temporary files, and environment files were not fully
  covered by ignore rules.

## Work Completed

- Added a minimum coordinate guard for polygon rendering.
- Added XCTest coverage for the polygon-rendering threshold.
- Added `make check` and `scripts/check-baseline.py` for dependency-free
  static verification.
- Verified plist, scheme, workspace, SVG, and screenshot artifacts without
  invoking Xcode.
- Added guardrails against accidental network upload, location authorization,
  analytics, or credential-bearing sample changes.
- Updated README, security, vision, changelog, and ignore rules.

## Verification

- `make check`
- `python3 scripts/check-baseline.py`
- `git diff --check`
