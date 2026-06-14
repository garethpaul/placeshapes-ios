# Security Policy

## Supported Versions

The supported security scope for `placeshapes-ios` is the current default branch, `master`. Older commits, tags, branches, forks, demos, and generated artifacts are not actively supported unless the repository explicitly marks them as maintained.

Project summary: Draw Shapes on Map

## Reporting a Vulnerability

Please report suspected vulnerabilities through GitHub's private vulnerability reporting or by opening a draft GitHub Security Advisory for `garethpaul/placeshapes-ios` when that option is available. If GitHub does not show a private reporting option for this repository, contact the repository owner through GitHub and avoid posting exploit details publicly until the issue can be assessed.

Do not open a public issue that includes exploit code, secrets, personal data, or detailed reproduction steps for an unpatched vulnerability.

## What to Include

Helpful reports include:

- the affected file, endpoint, permission, dependency, or workflow
- a concise impact statement explaining what an attacker could do
- reproduction steps using test data and accounts you control
- the branch, commit SHA, platform version, device, runtime, or dependency versions used
- logs, screenshots, or proof-of-concept snippets that demonstrate impact without exposing private data

## Project Security Posture

- This repository appears to be an Apple platform application or Swift sample. The active security scope is the code and documentation on the default branch.
- Review found network clients, sockets, web APIs, or service endpoints; changes in those areas should receive security-focused review before merge.
- Review found mobile permission or privacy-sensitive data handling; changes in those areas should receive security-focused review before merge.
- Review found file, document, data, or media parsing flows; changes in those areas should receive security-focused review before merge.
- The current MapKit sample keeps drawn coordinates local by default. No
  network upload, analytics export, or location-sharing behavior is implemented
  in the checked-in source.
- Dependency manifests detected: Podfile. Dependency updates should preserve lockfiles when present and avoid introducing packages without a clear maintenance reason.

## Mobile Privacy Notes

If this project requests device permissions such as location, camera, microphone, contacts, Bluetooth, health data, or local storage access, reports should describe the permission involved and whether sensitive data can be accessed, persisted, or transmitted unexpectedly. Please avoid testing against real third-party user data or accounts you do not control.

Map drawings can represent private homes, workplaces, routes, or sensitive
places. Reports about coordinate export, persistence, upload, analytics, or
sharing behavior should include the code path and whether user consent is
visible.
Keep non-placeholder XCTest coverage around coordinate-count rules so malformed
input remains predictable.
Polygon construction should require at least three distinct valid coordinates;
repeated points must not turn a one- or two-point draft into an accepted shape.
Polygon construction should also require non-collinear coordinates so distinct
points on one line cannot produce a zero-area overlay.
Starting polygon drafts should clear stale coordinates before collecting the
next touch path.
Cancelled touches should clear in-progress polygon draft coordinates so stale
points are not retained in the editing flow.
Cancelled touch callbacks should clear stale polygon drafts even if edit mode
has already changed.
Leaving edit mode should also clear in-progress polygon draft coordinates before
normal map interaction resumes.
Finalized polygon drafts should clear the raw coordinate buffer after invalid
or successful touch-end handling so private place data is not retained longer
than needed.
Map view delegate outlet setup should tolerate unconnected scaffold instances
used by tests or static review.
The touch input map outlet should clear partial coordinates and return safely
when the map view is unavailable.
Keep the CocoaPods platform matched to the Xcode iOS deployment target so
dependency integration does not silently target a different OS floor.
Keep plist bundle identifiers and plist package types explicit so framework and
test target metadata stays reviewable when Xcode is unavailable.

## Dependency and Supply Chain Security

Dependency updates should come from trusted package managers and should keep lockfiles in sync when lockfiles exist. Do not commit credentials, private keys, tokens, generated secrets, or machine-local configuration. If a vulnerability depends on a compromised package, typosquatting risk, insecure transitive dependency, or unsafe build step, include the package name, affected version, and the path through which it is used.

Run `make lint`, `make test`, `make build`, `make verify`, and `make check`
before changing project metadata, MapKit drawing behavior, privacy docs, or
CocoaPods configuration.
Pinned, read-only hosted macOS structural validation runs without credentials,
pod installation, signing, network calls, or location-service access.
Keep credential-free signing metadata free of Apple development team IDs,
provisioning profiles, entitlements paths, and account-specific certificates.

## Safe Research Guidelines

Good-faith research is welcome when it stays within these boundaries:

- use only accounts, devices, data, and infrastructure that you own or have explicit permission to test
- avoid destructive actions, persistence, spam, phishing, social engineering, or denial-of-service testing
- minimize access to personal data and stop testing immediately if private data is exposed
- do not exfiltrate secrets or third-party data; report the minimum evidence needed to verify impact
- keep vulnerability details confidential until the maintainer has assessed the report

## Maintainer Response

The maintainer will review complete reports as availability allows, prioritize issues by exploitability and impact, and coordinate a fix or mitigation when the affected code is still maintained. For sample, archived, or educational repositories, the likely remediation may be documentation, dependency updates, or clearly marking unsupported code rather than a production-style patch release.
