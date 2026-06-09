# Cancelled Polygon Drafts Plan

status: completed

## Context

The touch-cancel path left the in-progress polygon coordinate buffer untouched.
Cancelled touches should clear draft state so stale coordinates are not reused
inside the editing flow.

## Objectives

- Add a `cancelPolygonDraft()` helper that clears draft coordinates.
- Call the helper from `touchesCancelled` while editing.
- Add XCTest and static checker coverage for the cancellation behavior.

## Verification

- `make check`
- `python3 scripts/check-baseline.py`
- `git diff --check`
