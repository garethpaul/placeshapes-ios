# Credential-free signing metadata

status: completed

## Context

The hosted baseline runs without signing, but the Xcode project contract does
not prevent account-specific development teams, provisioning profiles,
entitlements paths, or signing certificates from being committed later.

## Requirements

- Reject `DEVELOPMENT_TEAM`, `PROVISIONING_PROFILE`,
  `PROVISIONING_PROFILE_SPECIFIER`, and `CODE_SIGN_ENTITLEMENTS` settings.
- Preserve only the existing generic `iPhone Developer` and empty signing
  identity values; reject account-specific certificate identities.
- Keep MapKit behavior, Swift sources, tests, project metadata, plists,
  workspace files, schemes, CocoaPods configuration, and workflow unchanged.
- Add offline static contracts, documentation, and completed verification.

## Verification

## Work completed

- Added project-file parsing that rejects `DEVELOPMENT_TEAM`,
  `PROVISIONING_PROFILE`, `PROVISIONING_PROFILE_SPECIFIER`, and
  `CODE_SIGN_ENTITLEMENTS` build settings.
- Required exactly the two generic `iPhone Developer` and two empty signing
  identities already present in the project.
- Updated contributor, security, vision, README, and change documentation.

## Verification completed

- `make lint`, `make test`, `make build`, `make verify`, and `make check`
  passed the no-Xcode structural baseline.
- Checker compilation, external-working-directory execution,
  `git diff --check`, artifact scans, and secret scans passed.
- The checker rejected six hostile mutations covering a development team,
  provisioning profile UUID, provisioning profile specifier, entitlements
  path, account-specific signing identity, and removed empty identity.
