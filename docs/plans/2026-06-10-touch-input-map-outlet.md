# Touch Input Map Outlet

status: completed

## Context

Delegate setup tolerated an unconnected `mapView`, but the active touch
callbacks still force-used the implicitly unwrapped outlet. A scaffold instance
or interrupted view lifecycle could therefore crash while retaining partial
polygon coordinates.

## Objectives

- Add `mapViewForTouchInput` as the single nil-safe touch input lookup.
- Clear draft coordinates when touch input has no connected map view.
- Guard `touchesBegan`, `touchesMoved`, and `touchesEnded` before conversion.
- Preserve normal coordinate conversion and polygon finalization when the outlet
  is connected.
- Cover unavailable-map cleanup with XCTest source and the static baseline.

## Verification

- `make lint`
- `make test`
- `make build`
- `make verify`
- `make check`
- Mutation: remove one touch callback guard and confirm `make check` fails.
- Mutation: remove draft cleanup from `mapViewForTouchInput` and confirm
  `make check` fails.
- `git diff --check`
