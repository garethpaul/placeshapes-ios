# Cancelled Touch Draft Reset Plan

status: completed

## Context

`touchesCancelled` cleared draft coordinates only while the controller still
reported editing mode. Touch cancellation can arrive during UI state changes,
so stale polygon coordinates should be discarded even if edit mode has already
changed.

## Objectives

- Clear polygon draft coordinates on every `touchesCancelled` callback.
- Preserve the existing edit-mode and finalization draft reset behavior.
- Add scaffold XCTest and static checker coverage for cancellation outside
  edit mode.
- Document the cancellation guardrail in README, SECURITY, VISION, and
  CHANGES.

## Verification

- `make check`
- `python3 scripts/check-baseline.py`
- `git diff --check`
