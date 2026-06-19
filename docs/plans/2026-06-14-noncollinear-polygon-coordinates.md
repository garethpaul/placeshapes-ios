# Non-Collinear Polygon Coordinates

status: completed

## Context

Polygon finalization rejects invalid coordinates and drafts with fewer than
three distinct points, but three or more distinct coordinates may still lie on
one line. Such a draft passes the current checks while producing a zero-area
`MKPolygon` overlay.

## Objectives

- Require at least one coordinate to be non-collinear with the first two
  distinct coordinates before constructing an `MKPolygon`.
- Preserve valid-coordinate and three-distinct-coordinate validation.
- Preserve draft cleanup for rejected and accepted finalization.
- Keep the helper compatible with the repository's Swift 3-era source style.
- Add mutation-sensitive XCTest source, static, documentation, and completed
  plan contracts.

## Scope Boundaries

- Do not change touch collection, edit-mode behavior, rendering style, project
  metadata, signing, dependencies, deployment target, networking, or privacy
  permissions.
- Do not claim a current-Xcode build or simulator result from the Linux host.
- Keep this work stacked on the location-independent Make pull request.

## Implementation Units

1. Add direct and finalization XCTest fixtures for horizontal and diagonal
   collinear drafts plus a nearby non-collinear control.
2. Add the smallest Swift 3-compatible cross-product predicate after valid and
   distinct coordinate checks.
3. Extend the structural checker and maintenance evidence for the non-collinear
   polygon boundary.

## Test Scenarios

- Three distinct horizontal coordinates are rejected.
- Three distinct diagonal coordinates are rejected.
- A draft with two points on one line and a third point off that line passes.
- Rejected finalization clears the draft without constructing an overlay.
- Existing invalid, duplicate-only, valid, and accepted-finalization fixtures
  remain unchanged.

## Work Completed

- Required the coordinate set to contain a point off the line defined by the
  first two distinct coordinates before constructing `MKPolygon`.
- Added horizontal and diagonal collinear rejection fixtures, a non-collinear
  accepted control, and rejected-finalization draft cleanup coverage.
- Extended structural and maintenance contracts without changing touch input,
  rendering, project metadata, signing, dependencies, or privacy behavior.

## Verification Completed

- `make lint`, `make test`, `make build`, `make verify`, and `make check` passed
  from the repository root.
- Absolute-Makefile `make check` and `make verify` passed from `/tmp`.
- `python3 -m py_compile scripts/check-baseline.py` passed.
- The workflow YAML, all three plists, workspace and scheme XML, and `README SVG`
  parsed successfully.
- `testPolygonRenderingRejectsDistinctCollinearCoordinates` records horizontal
  and diagonal rejection, while accepted fixtures use non-collinear controls.
- `testCollinearPolygonFinalizationClearsDraftCoordinates` records nil overlay
  creation and draft cleanup for a rejected zero-area draft.
- Six isolated hostile mutations were rejected: source predicate bypass,
  zero-tolerance regression, direct fixture removal, finalization fixture
  removal, documentation removal, and incomplete plan status.
- `git diff --check`, exact intended-path review, protected project and signing
  path checks, generated-artifact inspection, privacy and personal-coordinate
  screening, and high-signal credential scanning passed across eight files.
