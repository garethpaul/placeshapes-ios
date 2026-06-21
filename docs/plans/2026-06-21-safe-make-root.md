# Safe Makefile Root Resolution

## Status

- completed

## Problem

The Makefile derived `REPO_ROOT` from `MAKEFILE_LIST`, but callers could
replace that automatic variable and redirect every documented quality gate to
an attacker-controlled path. Paths containing spaces or apostrophes also need
to remain usable for disposable exact-head validation. The first verifier only
inspected dry-run text, so caller-controlled `SHELL` still executed before the
assertions and double quotes or backticks in a checkout path remained unsafe
at recipe execution time.

## Completed Work

- Reject command-line and environment overrides of `MAKEFILE_LIST`.
- Reject non-empty `MAKEFILES` preload configuration.
- Freeze the recipe shell, shell flags, and Python command against Make
  command-line and environment overrides.
- Resolve the trusted Makefile path to a canonical, shell-quoted repository
  root, including when an earlier explicit Makefile is present.
- Ignore caller-supplied `REPO_ROOT` values for every public target.
- Replace dry-run text checks with executable stub gates for all eight public
  Make targets.

## Verification Completed

- `make check`
- `make lint`
- `make test`
- `make build`
- `make verify`
- `make static-check`
- `make root-test`
- 72 executable target and authority-override combinations passed from a
  temporary path containing repeated spaces, brackets, apostrophes, double
  quotes, and backticks.
- Command-line and environment `MAKEFILE_LIST` overrides failed closed.
- Command-line and environment `MAKEFILES` preload attempts failed closed.
- An earlier explicit Makefile preserved the trusted repository root.

## Trust Boundary

GNU Make parses caller-supplied preload and explicit Makefiles before this
repository can reject them. Those files, the host `PATH`, and the `python3`
executable selected from it remain caller/runner trust inputs rather than code
this repository can sandbox.
