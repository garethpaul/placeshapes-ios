# Consecutive Touch Sample Deduplication

status: completed

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

## Work Completed

- Added `appendCoordinateToDraft(_:)` with a consecutive equality guard.
- Replaced direct coordinate appends in begin, move, and end touch callbacks.
- Added helper-level acceptance/rejection tests and an integration regression for
  a repeated final sample.
- Synchronized maintained guidance, change history, and mutation-sensitive
  source/test/documentation contracts.

## Verification Completed

- All five Make aliases passed: `make lint`, `make test`, `make build`,
  `make verify`, and `make check`.
- The absolute Makefile check passed from an external directory after correcting
  an initial shell command that expanded `$PWD` after entering the temporary
  directory.
- The Make root suite passed 72 executable target/override cases, four rejected
  preload cases, and one earlier-Makefile case.
- Python and shell syntax checks passed, `git diff --check` passed, and focused
  structural validation found 31 XCTest methods.
- Six isolated hostile mutations were rejected for the equality guard, touch
  callback routing, integration regression, README guidance, completed plan
  status, and hosted run evidence.
- Hosted macOS structural and native XCTest workflow runs `28165391772` and
  `28165394470` passed, including all 31 XCTest methods.
- Codex review reported no actionable diff-introduced findings, and CodeQL
  actions/Python analysis passed.
