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
3. Disable checkout credential persistence and assign repository ownership.
4. Preserve polygon draft-state, project, plist, scheme, and fixture checks.
5. Keep pods, signing, networking, and location services out of CI.
6. Enforce the sole-workflow contract from `scripts/check-baseline.py`.

## Implementation Units

Add a commit-pinned, read-only Python 3.12 job on `macos-15` that runs
`make check`, does not persist checkout credentials, and uses CODEOWNERS for
review routing. Keep this explicitly separate from a future dependency and
Xcode modernization pass.

## Work Completed

- Added a commit-pinned, read-only `macos-15` workflow that runs the canonical
  structural gate for pushes, pull requests, and manual dispatches.
- Disabled checkout credential persistence and assigned repository ownership
  through `.github/CODEOWNERS`.
- Enforced the sole-workflow contract, exact action commits, Python 3.12,
  timeout, concurrency, and `make check` command from the static baseline.
- Preserved all polygon draft-state, Xcode project, plist, scheme, fixture, and
  documentation checks without installing pods or accessing location services.

## Verification Completed

- Local `make lint`, `make test`, `make build`, `make verify`, and `make check`
  passed the complete structural baseline.
- `python3 -W error scripts/check-baseline.py` and `git diff --check` passed.
- Five hostile workflow and ownership mutations were rejected, covering
  credential persistence, duplicate checkout, duplicate credential settings,
  an extra workflow, and changed CODEOWNERS assignment.
- GitHub Actions push run `27390781674` and pull-request run `27390782458`
  completed successfully on exact implementation head
  `8fb27207d644485cba7795a186c0132261608dc6` using `macos-15` and Python 3.12.
- The workflow preserves checkout commit
  `df4cb1c069e1874edd31b4311f1884172cec0e10`, setup-python commit
  `a309ff8b426b58ec0e2a45f0f869d46889d02405`, and
  `persist-credentials: false`.
- `.github/CODEOWNERS` preserves `* @garethpaul`, and `check.yml` remains the
  repository's only hosted workflow.

## Boundaries

- Do not install pods, sign targets, or access location services.
- Do not change Swift behavior, deployment targets, or dependencies.
- Do not claim current Xcode build compatibility.
