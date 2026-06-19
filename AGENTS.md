# AGENTS.md

## Repository purpose

`garethpaul/placeshapes-ios` is a Swift 3 / MapKit sample for drawing shapes on a map. It converts local touch points into map coordinates and renders them as an `MKPolygon` overlay.

## Project structure

- `Makefile` - repository verification targets
- `scripts` - baseline checks and helper scripts
- `docs` - plans, notes, and generated README assets
- `Podfile` - CocoaPods dependency definition
- `PlaceShapes.xcodeproj` - Xcode project
- `PlaceShapes` - repository source or sample assets
- `PlaceShapesTests` - repository source or sample assets
- `screenshots` - repository source or sample assets

## Development commands

- Install dependencies: `pod install`
- Full baseline: `make check`
- Combined verification: `make verify`
- Lint/static checks: `make lint`
- Tests: `make test`
- Build: `make build`
- Local Apple development: `open PlaceShapes.xcodeproj`
- If a command above skips because a platform toolchain is missing, verify on a machine with that SDK before claiming platform behavior is tested.

## Coding conventions

- Language mix noted in the README: Swift (2), C/C++ headers (1).
- Use the CocoaPods workspace when present; update `Podfile.lock` only with an intentional dependency change.
- Preserve legacy Xcode project settings and signing assumptions unless the change is explicitly about modernization.

## Testing guidance

- Test-related files detected: `docs/plans/2026-06-09-non-placeholder-xctest.md`, `PlaceShapesTests/PlaceShapesTests.swift`
- Start with the narrowest relevant test or Make target, then run `make check` before handing off if the change is not documentation-only.
- Keep README verification notes in sync when commands, fixtures, or supported toolchains change.

## PR / change guidance

- Keep diffs focused on the requested repository and avoid unrelated modernization or formatting churn.
- Preserve public APIs, sample behavior, file formats, and documented environment variables unless the task explicitly changes them.
- Update tests, README notes, or docs/plans when behavior, security posture, or validation commands change.
- Call out skipped platform validation, legacy toolchain assumptions, and any risky files touched in the final summary.

## Safety and gotchas

- No required secret or credential file was identified in the repository scan. If you add integrations later, keep secrets out of git.
- Do not commit personal map coordinates, recorded routes, simulator captures with private places, or machine-local Xcode state.
- Preserve credential-free signing metadata; do not add Apple development team
  IDs, provisioning profiles, entitlements paths, or account-specific signing
  identities to the Xcode project.
- Map drawings can represent private places. No network upload behavior should be added without prominent README and security updates.
- This looks like an Apple platform project or sample. Xcode, Swift, CocoaPods, and deployment target versions may need to match the original project era.
- Run `make lint`, `make test`, `make build`, `make verify`, and `make check` before changing project metadata, MapKit drawing behavior, or privacy-related docs.
- Keep non-placeholder XCTest coverage in place when changing polygon creation rules.

## Agent workflow

1. Inspect the README, Makefile, manifests, and the files directly related to the request.
2. Make the smallest source or docs change that satisfies the task; avoid generated, vendored, or local-environment files unless required.
3. Run the narrowest useful validation first, then `make check` or the documented package/platform gate when available.
4. If a required SDK, service credential, or external runtime is unavailable, record the skipped command and why.
5. Summarize changed files, commands run, and remaining risks or follow-up validation.
