# Podfile Deployment Target Alignment Plan

status: completed

## Context

The Xcode project declares `IPHONEOS_DEPLOYMENT_TARGET = 10.1`, but the
Podfile used `platform :ios, '10.0'`. That mismatch can make future pod
installation or dependency review reason about a lower OS floor than the
project actually builds for.

## Objectives

- Align the Podfile platform with the Xcode iOS 10.1 deployment target using
  `platform :ios, '10.1'`.
- Extend the static baseline so the Podfile and Xcode project target stay in
  sync.
- Document the deployment-target contract for future CocoaPods edits.

## Verification

- `make check`
- `python3 scripts/check-baseline.py`
- `git diff --check`
