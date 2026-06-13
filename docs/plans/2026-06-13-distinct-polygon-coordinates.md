# Distinct Polygon Coordinates

status: pending

## Context

Polygon finalization currently requires three valid coordinate entries, but
three entries can contain only one or two distinct points. Such a draft passes
the count and range checks while producing a degenerate zero-shape overlay.

## Requirements

- Require at least three distinct valid latitude/longitude pairs before
  constructing an `MKPolygon`.
- Keep the helper compatible with the repository's Swift 3-era source style.
- Preserve draft cleanup for rejected and accepted finalization.
- Add valid duplicate, all-identical, and two-distinct-point XCTest fixtures.
- Add mutation-sensitive source, test, documentation, and completed-plan
  contracts.

## Scope Boundaries

- Do not change touch collection, rendering style, editing behavior, project
  metadata, signing, dependencies, deployment target, networking, or privacy
  permissions.

## Work Completed

Pending implementation.

## Verification Completed

Pending implementation and validation.
