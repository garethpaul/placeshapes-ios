# Edit Mode Draft Reset Plan

status: completed

## Context

Cancelled touches already clear in-progress polygon coordinates, but a user can
also leave edit mode before a touch sequence produces a valid polygon. That
path should not retain stale draft coordinates after normal map interaction is
restored.

## Objectives

- Clear in-progress polygon draft coordinates when leaving edit mode.
- Keep map interaction toggling intact for edit and normal modes.
- Use optional map-view access so the edit-mode reset path is testable without
  requiring the IBOutlet to be connected.
- Add XCTest and static checker coverage for `setEditing(false, animated:
  false)`.
- Document the edit-mode draft reset behavior.

## Verification

- `make check`
- `git diff --check`
