# placeshapes-ios

<!-- README-OVERVIEW-IMAGE -->
![Project overview](docs/readme-overview.svg)

## Overview

`garethpaul/placeshapes-ios` is a Swift 3 / MapKit sample for drawing shapes on a
map. It converts local touch points into map coordinates and renders them as an
`MKPolygon` overlay.

The current sample keeps drawn coordinates local by default. No network upload,
analytics export, or location-sharing behavior is implemented in the checked-in
source.

This README is based on the checked-in source, manifests, scripts, and repository metadata on the `master` branch. The project language mix found during review was: Swift (2), C/C++ headers (1).

## Repository Contents

- `.gitignore` - generated Xcode, local state, and cache ignores
- `CHANGES.md` - baseline change log
- `Makefile` - static verification entry point
- `README.md` - project overview and local usage notes
- `Podfile` - Apple platform dependency metadata
- `PlaceShapes` - source or example code
- `PlaceShapes.xcodeproj` - Xcode project file
- `PlaceShapesTests` - source or example code
- `SECURITY.md` - security reporting and disclosure guidance
- `VISION.md` - project direction and maintenance guardrails
- `docs/plans/2026-06-08-placeshapes-baseline.md` - completed baseline plan
- `scripts/check-baseline.py` - static checks for project and privacy guardrails

Additional scan context:

- Source directories: PlaceShapes, PlaceShapes.xcodeproj, PlaceShapesTests
- Dependency and build manifests: `Makefile`, `Podfile`
- Entry points or build surfaces: PlaceShapes.xcodeproj
- Test-looking files: PlaceShapesTests/Info.plist, PlaceShapesTests/PlaceShapesTests.swift

## Getting Started

### Prerequisites

- Git
- macOS with Xcode for building Apple platform projects
- CocoaPods if dependencies need to be installed

### Setup

```bash
git clone https://github.com/garethpaul/placeshapes-ios.git
cd placeshapes-ios
pod install
make check
```

The setup commands above are derived from repository files. Legacy mobile, Python, or JavaScript samples may require older SDKs or package versions than a modern workstation uses by default.

## Running or Using the Project

- Open `PlaceShapes.xcodeproj` in Xcode, choose the app or sample scheme, and run it on the matching simulator/device.
- Use `PlaceShapes/PlaceShapes.swift` as the drawing behavior reference: edit
  mode collects touch coordinates and renders the resulting `MKPolygon`.
- The CocoaPods platform matches the iOS 10.1 deployment target declared by
  the Xcode project.
- Framework and test plist bundle identifiers use `PRODUCT_BUNDLE_IDENTIFIER`,
  and plist package types stay explicit for the framework and XCTest bundle.
- The map view delegate outlet assignment tolerates an unconnected `mapView`
  during scaffold checks.
- The touch input map outlet is guarded before coordinate conversion, and an
  unavailable map clears any partial polygon draft.
- Keep coordinates local unless a future change explicitly documents export,
  sharing, or upload behavior.
- The test target keeps non-placeholder XCTest coverage for minimum and invalid
  polygon coordinate counts.
- Polygon finalization also rejects out-of-range Core Location latitude or
  longitude values before constructing an `MKPolygon`, and clears the rejected
  draft coordinate buffer.
- Polygon finalization requires at least three distinct valid coordinates, so
  repeated points cannot turn a one- or two-point draft into a rendered shape.
- Polygon finalization also rejects distinct but collinear coordinates so
  zero-area drafts cannot replace the current overlay.
- Starting polygon drafts clears any stale coordinates before collecting the
  next touch path.
- Cancelled touches clear in-progress polygon draft coordinates.
- Cancelled touch callbacks clear stale polygon drafts even if edit mode has
  already changed.
- Leaving edit mode also clears in-progress polygon draft coordinates before
  the map returns to normal interaction.
- Finalized polygon drafts clear the raw coordinate buffer whether the draft is
  too short to render or successfully becomes an `MKPolygon`.
- Self-intersecting polygon drafts are rejected before `MKPolygon`
  construction, while valid concave drafts remain supported.
- Zero-length polygon edges, including an explicitly repeated closing vertex,
  are rejected before `MKPolygon` construction.
- Longitude validation treats `180` and `-180` as the same meridian and unwraps
  antimeridian-crossing drafts before planar intersection checks.

## Example

The local PlaceShapes screenshot shows a polygon drawn over the map:

![PlaceShapes polygon drawn on a map](screenshots/001.png)

## Testing and Verification

- `make check`
- `make lint`
- `make test`
- `make build`
- `make verify`
- `make native-test`
- `python3 scripts/check-baseline.py`
- Xcode's test action or `xcodebuild test` with the appropriate scheme and destination on a macOS machine with the matching Apple toolchain

The Make lint, test, build, verify, and check targets all run the static
baseline on hosts without the matching legacy Xcode toolchain.
Pinned hosted macOS structural validation runs the same `make check` contract
on Python 3.12 without installing pods, signing, or invoking location services.
The same hosted job runs native XCTest on an available iPhone simulator with a
Swift 5 compatibility override, while the project retains its Swift 3 metadata.
Credential-free signing metadata is enforced in the Xcode project: no Apple
development team, provisioning profile, entitlements path, or account-specific
signing identity may be committed.

When the required SDK or runtime is unavailable, use static checks and source review first, then verify on a machine that has the matching platform toolchain.

## Configuration and Secrets

- No required secret or credential file was identified in the repository scan. If you add integrations later, keep secrets out of git.
- Do not commit personal map coordinates, recorded routes, simulator captures
  with private places, or machine-local Xcode state.

## Security and Privacy Notes

- Review changes touching network requests, sockets, or service endpoints; examples from the scan include PlaceShapes/Info.plist, PlaceShapes.xcodeproj/xcuserdata/gpj.xcuserdatad/xcschemes/xcschememanagement.plist, PlaceShapesTests/Info.plist.
- Review changes touching mobile permissions or privacy-sensitive device data; examples from the scan include PlaceShapes/PlaceShapes.swift.
- Review changes touching file, media, JSON, XML, CSV, OCR, or data parsing; examples from the scan include PlaceShapes/Info.plist, PlaceShapes.xcodeproj/xcuserdata/gpj.xcuserdatad/xcschemes/xcschememanagement.plist, PlaceShapesTests/Info.plist.
- Map drawings can represent private places. No network upload behavior should
  be added without prominent README and security updates.

## Maintenance Notes

- Standard Make aliases resolve the structural checker from `Makefile`, so an
  absolute Makefile path works from another directory without changing scope.
- This looks like an Apple platform project or sample. Xcode, Swift, CocoaPods, and deployment target versions may need to match the original project era.
- Run `make lint`, `make test`, `make build`, `make verify`, and `make check`
  before changing project metadata, MapKit drawing behavior, or
  privacy-related docs.
- Keep non-placeholder XCTest coverage in place when changing polygon creation
  rules.
- Keep coordinate-aware polygon validation using
  `CLLocationCoordinate2DIsValid` before `MKPolygon` construction.
- Keep non-collinear coordinate validation after valid and distinct checks.
- Keep starting polygon drafts from reusing stale coordinates.
- Keep cancelled touches from leaving stale polygon draft coordinates.
- Keep cancelled touch callbacks clearing stale polygon drafts regardless of
  current edit mode.
- Keep leaving edit mode from retaining stale polygon draft coordinates.
- Keep finalized polygon drafts from retaining stale raw coordinate buffers.
- Keep the CocoaPods platform aligned with the Xcode iOS deployment target.
- Keep plist bundle identifiers and plist package types explicit when editing
  framework or test target metadata.
- Keep the map view delegate outlet assignment safe for unconnected scaffold
  instances.
- See `docs/plans/2026-06-09-make-gate-aliases.md` for the local Make gate
  aliases.
- See `SECURITY.md` for vulnerability reporting and safe research guidance.
- See `CHANGES.md` and `docs/plans/2026-06-08-placeshapes-baseline.md` for
  the current static baseline.
- See `VISION.md` for project direction and contribution guardrails.

## Contributing

Keep changes small and tied to the project that is already present in this repository. For code changes, document the toolchain used, avoid committing generated dependency directories or local configuration, and update this README when setup or verification steps change.
