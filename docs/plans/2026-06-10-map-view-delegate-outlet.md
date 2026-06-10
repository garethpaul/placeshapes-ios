# Map View Delegate Outlet

status: completed

## Context

`viewDidLoad` assigned the map view delegate through the implicitly unwrapped
`mapView` outlet. Other scaffold paths already use optional access so helper
tests and static review can instantiate the controller without a connected
storyboard outlet.

## Objectives

- Assign the map view delegate only when the outlet is connected.
- Preserve normal MapKit delegate setup when the storyboard connects `mapView`.
- Extend static checks and docs for the map view delegate outlet behavior.

## Verification

- `make check`
- `python3 scripts/check-baseline.py`
- `git diff --check`
