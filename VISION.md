## PlaceShapes iOS Vision

This document explains the current state and direction of the project.
Project overview and developer docs: [`README.md`](README.md)

PlaceShapes iOS is a Swift MapKit sample for drawing a polygon on a map by
collecting touch coordinates and rendering an `MKPolygon` overlay.

The repository is useful as a focused interaction example: edit mode freezes
map movement, touch input becomes map coordinates, and the resulting polygon is
shown with a custom renderer.

The goal is to keep the drawing behavior easy to understand while making the
library and app integration path clearer.

The current focus is:

Priority:

- Preserve the direct touch-to-coordinate drawing flow
- Keep MapKit overlay rendering simple and visible
- Maintain the README example and screenshot context
- Avoid changing gesture behavior without a sample app check

Next priorities:

- Document supported Xcode, Swift, and iOS versions
- Add a small sample app flow that demonstrates importing `PlaceShapes`
- Add tests or manual verification notes for polygon creation
- Clarify how callers can read, reset, and style drawn shapes

Contribution rules:

- One PR = one focused drawing, API, packaging, or documentation change.
- Include simulator notes for interaction changes.
- Keep public API changes small and documented.
- Do not introduce network or location upload behavior.

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
