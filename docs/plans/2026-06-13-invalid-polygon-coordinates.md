# Invalid Polygon Coordinate Validation

status: completed

## Context

Polygon finalization currently checks only that a draft contains at least three
coordinates. A malformed or out-of-range `CLLocationCoordinate2D` can therefore
reach `MKPolygon` construction even though Core Location already provides a
stable validity predicate. The roadmap explicitly calls for invalid-coordinate
fixtures.

## Priorities

1. Reject invalid latitude or longitude values before polygon construction.
2. Preserve the existing minimum-coordinate rule and clear rejected drafts.
3. Add focused XCTest and static-contract coverage without changing gestures,
   rendering, persistence, networking, or project metadata.

## Requirements

- R1. Add a coordinate-aware polygon-rendering predicate that requires at
  least three coordinates and validates each value with
  `CLLocationCoordinate2DIsValid`.
- R2. Keep the existing count-only predicate for its current callers and tests.
- R3. Make draft finalization use the coordinate-aware predicate before
  constructing `MKPolygon`.
- R4. Clear the draft and return `nil` for invalid latitude or longitude values.
- R5. Add XCTest fixtures for valid coordinates, latitude above 90, and
  longitude above 180.
- R6. Keep implementation compatible with the existing Swift 3 source style;
  do not use newer collection convenience APIs.
- R7. Update repository guidance and enforce implementation, tests, and
  completed evidence through the static baseline.

## Implementation Units

### U1: Coordinate Guard

File: `PlaceShapes/PlaceShapes.swift`

Add a simple loop-based coordinate predicate and use it during draft
finalization.

### U2: Regression Coverage

File: `PlaceShapesTests/PlaceShapesTests.swift`

Cover valid and out-of-range coordinate arrays and verify invalid finalization
clears the draft buffer.

### U3: Guidance And Static Contract

Files: `README.md`, `VISION.md`, `CHANGES.md`, `scripts/check-baseline.py`,
`docs/plans/2026-06-13-invalid-polygon-coordinates.md`

Document and enforce the coordinate-validity boundary and truthful completed
verification evidence.

## Verification Plan

- run the focused static checker for implementation and XCTest contracts
- `make lint`
- `make test`
- `make build`
- `make verify`
- `make check`
- run the checker from an external working directory
- parse workflow YAML, plists, workspace XML, and README SVG
- run focused hostile mutations against predicate, finalization, tests, draft
  clearing, documentation, and completed-evidence requirements
- `git diff --check`
- scan intended paths for secrets, personal coordinates, and generated artifacts

## Scope Boundaries

- Do not change touch collection, edit-mode behavior, polygon rendering style,
  map configuration, public persistence, export, analytics, or networking.
- Do not change Xcode metadata, signing, plists, workspace, Podfile, workflow,
  deployment targets, or dependencies.
- Do not claim a current Xcode build or simulator interaction was tested on the
  Linux development host.

## Work Completed

Added coordinate-aware polygon validation using Core Location's stable validity
predicate, switched draft finalization to that guard, and added valid,
invalid-latitude, invalid-longitude, and invalid-draft clearing XCTest fixtures.

## Verification Completed

- `make lint`, `make test`, `make build`, `make verify`, and `make check`
  passed the static baseline.
- The checker passed from an external working directory.
- The workflow YAML, plist and workspace XML, and README SVG parsed
  successfully.
- Ten focused hostile mutations rejected weakened predicate, finalization,
  fixture, draft-clearing, documentation, status, and evidence contracts.
- `git diff --check` passed.
- The `secret, personal-coordinate, and generated-artifact scan` passed.
- Xcode and simulator validation were unavailable because the Linux host does
  not provide the matching Apple toolchain.
