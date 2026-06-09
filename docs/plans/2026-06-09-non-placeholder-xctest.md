# Non-Placeholder XCTest

status: completed

## Context

The PlaceShapes test target contained generated placeholder XCTest methods
alongside the polygon rendering threshold test. The placeholders did not verify
any drawing behavior.

## Objectives

- Preserve the existing polygon minimum-coordinate test.
- Remove generated placeholder XCTest methods.
- Add coverage for invalid negative coordinate counts with
  `testPolygonRenderingRejectsNegativeCoordinateCounts`.
- Extend `make check` and docs so placeholders do not return.

## Verification

- `make check`
- `python3 scripts/check-baseline.py`
- `git diff --check`

Full Xcode test execution still requires macOS with a compatible Xcode version.
