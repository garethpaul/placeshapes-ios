# Non-Collinear Polygon Coordinates

status: planned

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

## Verification

- Root and external-directory structural Make aliases.
- Python checker compilation plus workflow, plist, workspace, scheme, SVG, and
  asset parsing.
- Mutation checks for source logic, direct and finalization fixtures,
  documentation, and completed plan evidence.
- Final intended-path, protected-path, generated-artifact, privacy, signing,
  personal-coordinate, and high-signal credential audits.
