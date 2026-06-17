# Zero-Length Polygon Edge Rejection

status: completed

## Problem

Polygon validation requires three distinct coordinates and a non-self-intersecting
ring, but it does not explicitly reject consecutive duplicate vertices. A draft
such as `[A, A, B, C]`, or an explicitly repeated closing vertex `[A, B, C, A]`,
can retain three distinct coordinates while creating a zero-length edge in the
ring passed to MapKit.

## Prioritized Requirements

- P0. Reject any polygon draft whose consecutive coordinates are identical.
- P0. Treat the implicit closing edge from the last coordinate to the first as
  consecutive, rejecting an explicitly repeated closing vertex.
- P1. Preserve valid convex and concave polygon acceptance plus existing finite,
  distinct, non-collinear, and simple-ring checks.
- P1. Keep invalid finalization draft cleanup and pre-overlay ordering unchanged.
- P1. Add mutation-sensitive XCTest source contracts, static checks,
  synchronized guidance, and completed verification evidence.

## Implementation Units

### U1. Nonzero ring-edge predicate

**Files:** `PlaceShapes/PlaceShapes.swift`

Add a deterministic coordinate-equality helper and a ring-edge validation pass
that compares every vertex with its successor modulo the coordinate count. Run
the guard before non-collinearity and intersection checks.

### U2. Source-level XCTest regressions

**Files:** `PlaceShapesTests/PlaceShapesTests.swift`

Add cases for an adjacent duplicate vertex, an explicitly repeated closing
vertex, and finalization cleanup after a zero-length edge is rejected. Preserve
the existing concave acceptance control.

### U3. Static contracts and guidance

**Files:** `scripts/check-baseline.py`, `README.md`, `SECURITY.md`, `VISION.md`,
`CHANGES.md`, `docs/plans/2026-06-17-zero-length-polygon-edges.md`

Protect the modulo edge scan, both rejection cases, finalization cleanup,
guidance, and completed plan evidence against isolated hostile mutations.

## Validation

- Run every Make alias and the absolute Makefile check from an external
  directory, plus structural parsing of Swift, project, plist, storyboard,
  asset, SVG, workflow, and plan contracts.
- Reject isolated mutations of the equality predicate, closing-edge modulo,
  validation wiring, regressions, guidance, and completed plan status.
- Audit the exact stacked diff, generated artifacts, credentials, conflict
  markers, modes, binaries, large files, and whitespace before committing.

## Scope Boundaries

- Do not change MapKit rendering, touch gesture behavior, deployment targets,
  dependencies, signing metadata, or the planar coordinate model.
- Do not claim Xcode, XCTest, simulator, device, spherical, or antimeridian
  runtime coverage from Linux structural validation.
- Do not merge or close any stacked pull request.

## Risks

- Exact floating-point equality is intentional because the rejected condition is
  an exactly zero-length edge; near-duplicate points remain valid input.
- The planar predicate remains suitable only for local touch-drawn polygons.
- This change is stacked on PR #9, which must remain open and merge first.

## Work Completed

- Added an exact coordinate-equality helper and a modulo ring scan that rejects
  adjacent duplicate vertices, including an explicitly repeated closing vertex.
- Wired nonzero-edge validation after distinct-coordinate validation and before
  non-collinearity and simple-ring checks.
- Added three zero-length edge regressions for adjacent duplicates, closing
  duplicates, and rejected-finalization draft cleanup while preserving the
  valid concave polygon control.
- Extended the static checker and synchronized README, security, vision, and
  changelog guidance.

## Verification Completed

- All Make aliases passed: `make lint`, `make test`, `make build`, `make verify`,
  and `make check`.
- `make -f /absolute/path/Makefile check` passed from an external working directory.
- Focused structural validation found 24 XCTest methods and protected
  `testPolygonRenderingRejectsAdjacentDuplicateCoordinate`,
  `testPolygonRenderingRejectsExplicitClosingCoordinate`, and
  `testZeroLengthEdgePolygonFinalizationClearsDraftCoordinates`.
- Six isolated hostile mutations were rejected: equality, closing-edge modulo,
  validation wiring, adjacent-duplicate regression, guidance, and completed
  plan status.
- `python3 -m py_compile scripts/check-baseline.py` and `git diff --check`
  passed.
- Xcode, XCTest, simulator, and device execution were not available on the
  Linux validation host; the pinned hosted macOS workflow remains authoritative
  for Apple-toolchain execution.
