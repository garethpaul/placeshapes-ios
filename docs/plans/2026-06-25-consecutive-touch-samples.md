# Consecutive Touch Sample Deduplication

status: in progress

## Context

UIKit can report the same final touch location in `touchesMoved` and
`touchesEnded`. Recording both samples creates an adjacent duplicate vertex,
which the intentional zero-length polygon edge validator rejects along with the
otherwise valid drawing.

## Requirements

- Ignore a coordinate only when it exactly matches the current final draft
  coordinate under the existing dateline-aware equality rule.
- Preserve distinct samples, non-adjacent duplicate rejection, and explicit
  closing-vertex rejection.
- Route all active touch callbacks through one append boundary.
- Keep coordinates local and preserve the framework's existing MapKit behavior.
- Cover the helper and a valid-triangle duplicate-lift scenario in XCTest and
  the portable static baseline.

## Implementation

- Add `appendCoordinateToDraft(_:)` with a consecutive equality guard.
- Replace direct coordinate appends in begin, move, and end touch callbacks.
- Add helper-level acceptance/rejection tests and an integration regression for
  a repeated final sample.
- Synchronize maintained guidance and change history.

## Verification

- Run all Make aliases and an absolute-Makefile external-directory check.
- Run Python and shell syntax validation plus `git diff --check`.
- Reject isolated mutations of the helper, callback routing, integration test,
  guidance, and completed plan evidence.
- Run hosted macOS native XCTest and Codex review before merge.
