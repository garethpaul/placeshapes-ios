# Safe Makefile Root Resolution

## Status

- completed

## Problem

The Makefile derived `REPO_ROOT` from `MAKEFILE_LIST`, but callers could
replace that automatic variable and redirect every documented quality gate to
an attacker-controlled path. Paths containing spaces or apostrophes also need
to remain usable for disposable exact-head validation.

## Completed Work

- Reject command-line and environment overrides of `MAKEFILE_LIST`.
- Resolve the trusted Makefile path to a canonical absolute repository root.
- Ignore caller-supplied `REPO_ROOT` values for every public target.
- Add deterministic regression coverage for all eight public Make targets.

## Verification Completed

- `make check`
- `make lint`
- `make test`
- `make build`
- `make verify`
- `make static-check`
- `make root-test`
- 24 target and `REPO_ROOT` override combinations passed from a temporary path
  containing spaces and an apostrophe.
- Command-line and environment `MAKEFILE_LIST` overrides failed closed.
