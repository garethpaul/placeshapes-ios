# Hosted Structural Validation

status: completed

## Context

The Swift 3/iOS 10.1 project has a structural safety gate but no hosted
validation. Its CocoaPods workspace is not reproducible because there is no
lockfile or checked-in pod installation, so a modern Xcode build would not be a
reliable regression contract.

## Priorities

1. Run the canonical structural gate for pushes and pull requests.
2. Pin macOS, actions, Python, permissions, timeout, and concurrency.
3. Preserve polygon draft-state, project, plist, scheme, and fixture checks.
4. Keep pods, signing, networking, and location services out of CI.
5. Enforce the workflow contract from `scripts/check-baseline.py`.

## Implementation Units

Add a commit-pinned, read-only Python 3.12 job on `macos-15` that runs
`make check`. Keep this explicitly separate from a future dependency and Xcode
modernization pass.

## Verification

- `make lint`
- `make test`
- `make build`
- `make check`
- workflow YAML parse
- `git diff --check`
- successful hosted macOS `Check` workflow for the pushed commit

## Boundaries

- Do not install pods, sign targets, or access location services.
- Do not change Swift behavior, deployment targets, or dependencies.
- Do not claim current Xcode build compatibility.
