# Distinct Polygon Coordinates

status: completed

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

- Added a Swift 3-compatible distinct-coordinate predicate after count and
  Core Location range validation and before `MKPolygon` construction.
- Added fixtures proving a four-entry draft with three distinct points passes,
  while three-entry drafts with only one or two distinct points fail.
- Added current privacy/maintenance guidance plus ordering-sensitive source,
  test, documentation, and completed-plan contracts.

## Verification Completed

- `make lint`, `make test`, `make build`, `make verify`, and `make check`
- Ran the baseline checker from an external working directory.
- Parsed the workflow YAML, Python checker, plist and workspace XML, and
  `README SVG`.
- Confirmed focused hostile mutations to distinct-point logic, fixtures,
  current documentation, and completed-plan evidence are rejected.
- `git diff --check`
- The intended-path secret, personal-coordinate, and generated-artifact scan
  passed; project metadata, signing, dependencies, touch collection, rendering,
  networking, privacy permissions, and deployment target had no diff.
