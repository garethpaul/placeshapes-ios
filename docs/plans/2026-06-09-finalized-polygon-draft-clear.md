# Finalized Polygon Draft Clear Plan

status: completed

## Context

Touch-end handling appended the final touch coordinates and then either returned
for too-short drafts or rendered an `MKPolygon`. In both paths the raw draft
coordinate buffer could remain on the controller after finalization, retaining
private map points longer than the interaction needed.

## Objectives

- Clear invalid polygon drafts after touch end rejects them.
- Clear successfully rendered polygon drafts after copying the coordinates into
  the `MKPolygon`.
- Centralize touch-end draft handling in `finalizePolygonDraft`.
- Preserve the existing minimum-coordinate rendering rule and overlay update
  behavior.
- Add XCTest source coverage and static checker assertions for the finalization
  boundary.

## Verification

- `make check`
- `python3 scripts/check-baseline.py`
- `git diff --check`

Full XCTest execution still requires macOS with a compatible Xcode version.
