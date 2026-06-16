# Simple Polygon Ring Validation

status: planned

## Context

Polygon finalization already rejects invalid coordinates, fewer than three
distinct points, and fully collinear drafts. A bow-tie draft still satisfies
those checks even though two non-adjacent edges cross, producing an invalid
self-intersecting ring before `MKPolygon` construction.

## Priority

P1 correctness: reject an invalid geometric ring at the existing finalization
boundary rather than rendering an ambiguous overlay.

## Requirements

- Reject drafts whose non-adjacent polygon edges cross, overlap while
  collinear, or meet at a repeated endpoint.
- Treat the closing edge from the last coordinate to the first as part of the
  ring.
- Preserve adjacent shared endpoints and valid concave polygons.
- Use one documented coordinate tolerance for orientation and on-segment
  comparisons so near-collinear calculations are deterministic.
- Preserve invalid-coordinate, distinct-point, non-collinear, and draft-reset
  behavior.
- Keep the implementation compatible with the repository's Swift 3-era source
  style and structural Linux validation.
- Add mutation-sensitive XCTest source, static, documentation, and completed
  plan contracts.

## Scope Boundaries

- Do not change touch collection, edit-mode behavior, rendering style, project
  metadata, signing, dependencies, deployment target, networking, or privacy
  permissions.
- Do not claim a current-Xcode build or simulator result from the Linux host.
- Keep this work stacked on PR #8; do not merge or close either pull request.

## Implementation Units

1. Add bow-tie rejection and concave-polygon acceptance fixtures in
   `PlaceShapesTests/PlaceShapesTests.swift`.
2. Add a small orientation and closed-ring segment-intersection predicate in
   `PlaceShapes/PlaceShapes.swift`, after the existing coordinate guards.
3. Extend `scripts/check-baseline.py`, maintenance guidance, and changelog
   evidence for the simple-ring boundary.

## Test Scenarios

- Four valid, distinct, non-collinear coordinates arranged as a bow tie are
  rejected.
- Non-adjacent collinear overlap and repeated-endpoint contact are rejected.
- A valid concave polygon remains accepted.
- Rejected self-intersecting finalization clears the draft and creates no
  overlay.
- Existing invalid, duplicate-only, collinear, valid, and accepted-finalization
  fixtures remain unchanged.

## Verification

- Run all Make aliases from the repository root and the complete gate through
  the absolute Makefile path from an external directory.
- Parse maintained plist, JSON, XML, YAML, and SVG artifacts through the
  existing structural checker.
- Reject isolated implementation, regression, guidance, and plan-status
  mutations.
- Audit exact intended paths, protected project/signing files, generated
  artifacts, credentials, binaries, modes, and whitespace.
