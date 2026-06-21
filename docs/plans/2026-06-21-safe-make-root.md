# Safe Make Root

status: completed

## Problem

GNU Make list functions split absolute Makefile paths on whitespace. A caller
could also replace `MAKEFILE_LIST`, redirecting structural or optional native
verification to another tree.

## Change

- Resolve the raw Makefile path with POSIX-compatible system tooling.
- Reject non-file origins for GNU Make's automatic `MAKEFILE_LIST` value.
- Keep the checkout-derived root under command-line and environment `REPO_ROOT`.
- Remove the phony native target's caller-directory-sensitive file prerequisite.
- Cover all eight public Make targets and paths with spaces or an apostrophe.
- Cover command-line and environment `MAKEFILE_LIST` override attempts.

## Validation

- Run the structural and root-policy gate from the repository and through a
  hostile absolute Makefile path.
- Cover the native-test target by dry-run path assertions without claiming an
  Xcode build on non-macOS hosts.
- Confirm hosted macOS structural/native jobs and CodeQL pass at the exact head.

## Boundaries

- Do not change Swift or Objective-C source, Xcode project metadata, signing,
  CocoaPods inputs, workflows, fixtures, or native build behavior.
