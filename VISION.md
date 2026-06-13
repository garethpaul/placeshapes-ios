## PlaceShapes iOS Vision

This document explains the current state and direction of the project.
Project overview and developer docs: [`README.md`](README.md)

PlaceShapes iOS is a Swift 3 MapKit sample for drawing a polygon on a map by
collecting touch coordinates and rendering an `MKPolygon` overlay.

The repository is useful as a focused interaction example: edit mode freezes
map movement, touch input becomes map coordinates, and the resulting polygon is
shown with a custom renderer.

The goal is to keep the drawing behavior easy to understand while making the
library and app integration path clearer.

Current baseline: `make lint`, `make test`, `make build`, `make verify`, and
`make check` perform static verification of the Xcode metadata, plists, MapKit
drawing surfaces, and local-coordinate privacy guardrails without requiring
Xcode.

The current focus is:

Priority:

- Preserve the direct touch-to-coordinate drawing flow
- Keep MapKit overlay rendering simple and visible
- Maintain the README example and screenshot context
- Avoid changing gesture behavior without a sample app check
- Keep drawn coordinates local by default
- Keep non-placeholder XCTest coverage for polygon creation rules
- Keep invalid latitude and longitude values from reaching polygon construction
- Keep degenerate drafts with fewer than three distinct coordinates from
  reaching polygon construction
- Keep starting polygon drafts from reusing stale coordinates
- Keep cancelled touches from retaining polygon draft coordinates
- Keep cancelled touch callbacks clearing stale drafts after edit mode changes
- Keep leaving edit mode from retaining polygon draft coordinates
- Keep finalized polygon drafts from retaining raw coordinate buffers
- Keep map view delegate outlet setup safe for unconnected scaffold instances
- Keep the touch input map outlet guarded before coordinate conversion
- Keep the no-pods structural validation gate running on pinned hosted macOS
- Keep the CocoaPods platform matched to the Xcode iOS deployment target
- Keep credential-free signing metadata free of Apple account, provisioning,
  entitlements, and certificate-specific values
- Keep plist bundle identifiers and plist package types explicit for targets
- Keep standard Make gate aliases available for local static verification

Next priorities:

- Document supported Xcode, Swift, and iOS versions
- Add a small sample app flow that demonstrates importing `PlaceShapes`
- Add tests or manual verification notes for polygon creation
- Clarify how callers can read, reset, and style drawn shapes
- Add Xcode/simulator verification notes when the matching Apple toolchain is
  available

Contribution rules:

- One PR = one focused drawing, API, packaging, or documentation change.
- Include simulator notes for interaction changes.
- Keep public API changes small and documented.
- Do not introduce network or location upload behavior.
- Keep `make lint`, `make test`, `make build`, `make verify`, and `make check`
  passing for metadata and local-coordinate guardrails.

## Security And Responsible Use

Canonical security policy and reporting:

- [`SECURITY.md`](SECURITY.md)

Map drawings can represent private places. The component should keep drawn
coordinates local by default and make any export or sharing behavior explicit.

## What We Will Not Merge (For Now)

- Silent coordinate upload or analytics
- Large UI redesigns unrelated to drawing behavior
- Gesture rewrites without manual verification
- Public API changes without README updates

This list is a roadmap guardrail, not a permanent rule.
Strong user demand and strong technical rationale can change it.
