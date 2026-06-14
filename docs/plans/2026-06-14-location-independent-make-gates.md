# Location-Independent Make Gates

status: planned

## Context

The dependency-free structural checker passes from the repository root and by
direct absolute script path, but an absolute Makefile invocation from another
working directory still resolves `scripts/check-baseline.py` against the
caller. Shared automation should use every standard alias without changing its
own directory.

## Requirements

- Derive an override-protected repository root from the Makefile location.
- Invoke the structural checker by its rooted path for `lint`, `test`, `build`,
  `verify`, and `check` without changing alias behavior.
- Preserve polygon validation contracts, credential-free signing metadata,
  workflow policy, source fixtures, and the no-Xcode structural boundary.
- Statically reject caller-relative or caller-overridable checker execution.
- Record completed repository-root and external-Makefile verification.

## Scope Boundaries

- Do not change Swift, XCTest, Xcode project, plist, workspace, asset catalog,
  workflow, signing, dependency, coordinate, gesture, MapKit, or privacy data.
- Do not claim a Linux-hosted Xcode build, simulator, or XCTest result.
- Do not weaken the structural checker or polygon draft contracts.

## Implementation Units

1. Root the Makefile's checker recipe while preserving every existing alias.
2. Extend `scripts/check-baseline.py` to require the rooted recipe, this plan,
   completed evidence, and maintenance documentation.
3. Document the external invocation contract in `README.md` and `CHANGES.md`.

## Verification Plan

- Run every standard alias from the repository root and through the absolute
  Makefile path from `/tmp`, including a caller-supplied root override.
- Compile the checker outside the repository and parse workflow YAML, plists,
  workspace/storyboard/XML, asset-catalog JSON, and README SVG.
- Run isolated hostile mutations over rooted execution and completed evidence.
- Audit intended paths, unchanged implementation/project surfaces, whitespace,
  generated artifacts, personal coordinates, and secret-like data.
