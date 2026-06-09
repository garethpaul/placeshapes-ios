# Beginning Polygon Draft Reset Plan

status: completed

## Context

`touchesBegan` cleared draft coordinates inline before collecting a new touch
path, while cancel and finalize behavior already used named helpers with focused
tests. The start-of-draft reset should stay explicit so stale coordinates are
not reused when a new polygon path begins.

## Objectives

- Add `beginPolygonDraft` as the named start-draft reset helper.
- Route `touchesBegan` through the helper before collecting map coordinates.
- Add no-Xcode XCTest coverage for the helper clearing stale coordinates.
- Extend static checks and docs for starting polygon drafts.

## Verification

- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
