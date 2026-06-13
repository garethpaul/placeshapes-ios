# Credential-free signing metadata

status: planned

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

- Run all Make gates, checker compilation, hostile mutations, diff checks,
  generated-artifact scans, and secret scans.
