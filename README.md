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
```

The setup commands above are derived from repository files. Legacy mobile, Python, or JavaScript samples may require older SDKs or package versions than a modern workstation uses by default.

## Running or Using the Project

- Open `PlaceShapes.xcodeproj` in Xcode, choose the app or sample scheme, and run it on the matching simulator/device.
- Use `PlaceShapes/PlaceShapes.swift` as the drawing behavior reference: edit
  mode collects touch coordinates and renders the resulting `MKPolygon`.
- The CocoaPods platform matches the iOS 10.1 deployment target declared by
  the Xcode project.
- Keep coordinates local unless a future change explicitly documents export,
  sharing, or upload behavior.
- The test target keeps non-placeholder XCTest coverage for minimum and invalid
  polygon coordinate counts.
- Cancelled touches clear in-progress polygon draft coordinates.
- Leaving edit mode also clears in-progress polygon draft coordinates before
  the map returns to normal interaction.

## Testing and Verification

- `make check`
- `python3 scripts/check-baseline.py`
- Xcode's test action or `xcodebuild test` with the appropriate scheme and destination on a macOS machine with the matching Apple toolchain

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

- This looks like an Apple platform project or sample. Xcode, Swift, CocoaPods, and deployment target versions may need to match the original project era.
- Run `make check` before changing project metadata, MapKit drawing behavior,
  or privacy-related docs.
- Keep non-placeholder XCTest coverage in place when changing polygon creation
  rules.
- Keep cancelled touches from leaving stale polygon draft coordinates.
- Keep leaving edit mode from retaining stale polygon draft coordinates.
- Keep the CocoaPods platform aligned with the Xcode iOS deployment target.
- See `SECURITY.md` for vulnerability reporting and safe research guidance.
- See `CHANGES.md` and `docs/plans/2026-06-08-placeshapes-baseline.md` for
  the current static baseline.
- See `VISION.md` for project direction and contribution guardrails.

## Contributing

Keep changes small and tied to the project that is already present in this repository. For code changes, document the toolchain used, avoid committing generated dependency directories or local configuration, and update this README when setup or verification steps change.
