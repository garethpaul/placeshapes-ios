# Changes

## 2026-06-26 11:13 PDT - P1 - Preserve host map interaction state

### Summary

Made edit-mode teardown restore the map view's pre-edit interaction setting
instead of unconditionally enabling host-owned interaction.

### Work completed

- Captured the map interaction state only when entering edit mode.
- Kept map movement disabled while editing and restored the captured value only
  when leaving an active edit session.
- Added XCTest regressions for initially enabled, initially disabled, and
  already-non-editing map views.
- Added mutation-sensitive portable source, test, documentation, and plan
  contracts.

### Threads

- None; the defect and expected host-state contract were fully observable in
  the checked-in controller and tests.

### Files changed

- `PlaceShapes/PlaceShapes.swift` — transition-aware map interaction restore.
- `PlaceShapesTests/PlaceShapesTests.swift` — host-state regressions.
- `scripts/check-baseline.py` — durable implementation and evidence contracts.
- `README.md`, `SECURITY.md`, `VISION.md` — integration-state guarantee.
- `docs/plans/2026-06-26-preserve-map-interaction-state.md` — implementation
  and verification record.
- `CHANGES.md` — this cycle record.

### Validation

- Red `python3 scripts/check-baseline.py` rejected the missing state capture,
  transition check, restore path, and unconditional enable.
- `make lint`, `make test`, `make build`, `make verify`, and `make check`
  passed.
- The absolute Makefile check passed from an external working directory.
- Python and shell syntax checks passed.
- Three isolated hostile mutations were rejected.
- `git diff --check` passed.
- The first hosted native run exposed a missing `MapKit` import in the new test
  file; production compilation had succeeded. Adding the explicit test import
  corrected that compile-only defect before final review.

### Bugs / findings

- P1 integration state: `setEditing(false, animated:)` always set
  `isUserInteractionEnabled` to `true`, overriding a map disabled by the host
  before editing or while already outside edit mode.

### Blockers

- Native XCTest requires macOS/Xcode and is delegated to the required hosted
  `macos-15` check; Linux validation covers the portable contract.

### Next action

- Validate the exact pull-request head with hosted XCTest and CodeQL, then
  merge only if the immutable review is clean.

## 2026-06-25 23:31 PDT - P2 - Document supported Apple toolchains

### Summary

Documented the repository's historical Xcode 8.1, Swift 3, and iOS 10.1
contract separately from its hosted current-compiler validation path.

### Work completed

- Added an explicit README support matrix derived from project and test-script
  metadata.
- Clarified that hosted `macos-15` uses its runner-default Xcode with
  `SWIFT_VERSION=5` and `IPHONEOS_DEPLOYMENT_TARGET=12.0` overrides.
- Added fail-closed documentation checks and advanced the roadmap.

### Threads

- None; the checked-in Xcode project, workflow, and test script were sufficient.

### Files changed

- `README.md` — legacy and hosted toolchain support boundaries.
- `VISION.md` — removed the completed documentation priority.
- `scripts/check-baseline.py` — durable support-matrix contracts.
- `CHANGES.md` — this cycle record.

### Validation

- Red `make check` — failed for the missing support matrix before documentation.
- `make check` — passed.
- `git diff --check` — passed.

### Bugs / findings

- P2 documentation: "supports Swift 3" alone was ambiguous because hosted tests
  intentionally compile with Swift 5 while preserving Swift 3 project metadata.

### Blockers

- Xcode 8.1 is not installed locally; no source or project behavior changed.

### Next action

- Add a small sample app flow demonstrating framework import and polygon use.

## 2026-06-25

- Ignored consecutive duplicate touch samples before polygon validation so a
  repeated final lift coordinate does not discard an otherwise valid drawing.

## 2026-06-21

- Hardened every public Make quality gate against `MAKEFILE_LIST`, `MAKEFILES`,
  `REPO_ROOT`, `SHELL`, shell-flag, and `PYTHON` redirection. Executable
  regressions cover temporary paths containing spaces, apostrophes, double
  quotes, and backticks.

## 2026-06-19

- Added hosted native XCTest coverage and dual Swift 3/modern MapKit overlay API
  spellings so current Xcode compiles the legacy sample, with a shared scheme
  that exposes the test action on clean checkout hosts.
- Replaced fixed-area geometry tolerance with scale-relative orientation checks,
  canonicalized the `180`/`-180` meridian, and unwrapped antimeridian-crossing
  drafts before polygon topology validation.
- Reconciled the local PlaceShapes screenshot into the maintained README.

## 2026-06-17

- Rejected zero-length polygon edges from adjacent duplicate coordinates and
  explicitly repeated closing vertices.

## 2026-06-16

- Rejected self-intersecting polygon drafts, including strict crossings,
  repeated non-adjacent contacts, and collinear overlap, while preserving valid
  concave polygons.

## 2026-06-14

- Made every standard Make alias resolve the structural checker from the
  repository root, including external absolute-Makefile calls.
- Rejected polygon drafts whose valid, distinct coordinates are all collinear,
  and replaced accepted zero-area fixtures with non-collinear controls.

## 2026-06-13

- Rejected degenerate polygon drafts containing fewer than three distinct valid
  coordinates, even when the raw coordinate count is three or greater.
- Rejected out-of-range Core Location coordinates before polygon construction
  and added valid, invalid-latitude, invalid-longitude, and draft-clearing tests.
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
