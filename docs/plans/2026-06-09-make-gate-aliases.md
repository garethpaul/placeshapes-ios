# Make Gate Aliases Plan

status: completed

## Context

`placeshapes-ios` already used `make check` to run static verification for the
legacy Xcode project, plist files, MapKit drawing source, tests, docs, and
privacy guardrails. The shared maintenance workflow also expects root lint,
test, build, verify, and check commands to exist.

## Objectives

- Add stable `make lint`, `make test`, `make build`, and `make verify` aliases.
- Keep all local aliases delegated to the static baseline on hosts without the
  matching legacy Xcode toolchain.
- Extend documentation and baseline checks so the Make gate contract stays
  visible.

## Verification

- `make lint`
- `make test`
- `make build`
- `make verify`
- `make check`
- `python3 scripts/check-baseline.py`
- `git diff --check`
