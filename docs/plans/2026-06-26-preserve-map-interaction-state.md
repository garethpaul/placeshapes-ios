# Preserve Map Interaction State

status: completed

## Context

The framework temporarily disables `MKMapView` interaction while polygon edit
mode is active. The previous teardown always enabled interaction, which
overwrote host-owned state when an embedding app had intentionally disabled the
map before editing or called `setEditing(false, animated:)` while already
outside edit mode.

## Requirements

- Capture the map view's interaction setting only when entering a new edit
  session.
- Keep map interaction disabled throughout editing.
- Restore the captured value only when leaving an active edit session.
- Continue clearing polygon draft coordinates whenever editing ends.
- Do not change polygon geometry, touch sampling, overlay rendering, project
  metadata, or the local-coordinate privacy boundary.
- Cover enabled, disabled, and already-non-editing host states in XCTest and the
  portable baseline.

## Work Completed

- Added transition-aware storage for the pre-edit map interaction setting.
- Replaced the unconditional `true` assignment with restoration of the captured
  host value.
- Added three focused XCTest regressions and fail-closed portable contracts.
- Synchronized maintained integration, security, vision, and change guidance.

## Verification Completed

- The initial `python3 scripts/check-baseline.py` run failed because the source
  lacked the state capture, transition check, restore path, and still contained
  the unconditional enable.
- `make lint`, `make test`, `make build`, `make verify`, and `make check` passed.
- `make -f /absolute/path/to/Makefile check` passed from an external working directory.
- `python3 -m py_compile scripts/check-baseline.py scripts/test-makefile-root.py`
  and `sh -n scripts/run-xcode-tests.sh` passed.
- `testLeavingEditingPreservesDisabledMapInteraction`,
  `testLeavingEditingRestoresEnabledMapInteraction`, and
  `testSettingNonEditingDoesNotEnableDisabledMapInteraction` define the native
  behavior boundary.
- Three isolated hostile mutations were rejected by the portable checker.
- `git diff --check` passed.
- Native XCTest is covered by the required hosted macOS check because the local
  Linux environment does not provide Xcode.

## Evidence

- Implementation: `PlaceShapes/PlaceShapes.swift`.
- Native regressions: `PlaceShapesTests/PlaceShapesTests.swift`.
- Portable contract: `scripts/check-baseline.py`.
