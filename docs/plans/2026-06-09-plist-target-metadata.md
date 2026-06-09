# Plist Target Metadata

status: completed

## Context

The static baseline parsed the framework and XCTest target plists but did not
assert their target metadata. The checked-in project relies on
`PRODUCT_BUNDLE_IDENTIFIER` expansion and distinct plist package types for the
framework and test bundle.

## Objectives

- Require `PlaceShapes/Info.plist` to use `PRODUCT_BUNDLE_IDENTIFIER` and
  `CFBundlePackageType=FMWK`.
- Require `PlaceShapesTests/Info.plist` to use `PRODUCT_BUNDLE_IDENTIFIER` and
  `CFBundlePackageType=BNDL`.
- Extend docs and the static baseline for plist target metadata.
- Keep the no-Xcode verification path unchanged.

## Verification

- `make lint`
- `make test`
- `make build`
- `make check`
- `git diff --check`
