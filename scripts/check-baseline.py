#!/usr/bin/env python3
"""Static baseline checks for the PlaceShapes iOS MapKit sample."""

from pathlib import Path
import plistlib
import re
import sys
import xml.etree.ElementTree as ET


ROOT = Path(__file__).resolve().parents[1]
PLAN = "docs/plans/2026-06-08-placeshapes-baseline.md"
HOSTED_VALIDATION_PLAN = "docs/plans/2026-06-10-hosted-structural-validation.md"
SIGNING_METADATA_PLAN = "docs/plans/2026-06-13-credential-free-signing-metadata.md"
INVALID_COORDINATES_PLAN = "docs/plans/2026-06-13-invalid-polygon-coordinates.md"
DISTINCT_COORDINATES_PLAN = "docs/plans/2026-06-13-distinct-polygon-coordinates.md"
REQUIRED = [
    ".github/CODEOWNERS",
    ".github/workflows/check.yml",
    ".gitignore",
    "CHANGES.md",
    "Makefile",
    "README.md",
    "SECURITY.md",
    "VISION.md",
    "Podfile",
    "PlaceShapes.xcodeproj/project.pbxproj",
    "PlaceShapes.xcodeproj/project.xcworkspace/contents.xcworkspacedata",
    "PlaceShapes.xcodeproj/xcuserdata/gpj.xcuserdatad/xcschemes/PlaceShapes.xcscheme",
    "PlaceShapes.xcodeproj/xcuserdata/gpj.xcuserdatad/xcschemes/xcschememanagement.plist",
    "PlaceShapes/Info.plist",
    "PlaceShapes/PlaceShapes.h",
    "PlaceShapes/PlaceShapes.swift",
    "PlaceShapesTests/Info.plist",
    "PlaceShapesTests/PlaceShapesTests.swift",
    "docs/readme-overview.svg",
    PLAN,
    "docs/plans/2026-06-09-non-placeholder-xctest.md",
    "docs/plans/2026-06-09-cancelled-polygon-drafts.md",
    "docs/plans/2026-06-09-edit-mode-draft-reset.md",
    "docs/plans/2026-06-09-podfile-deployment-target.md",
    "docs/plans/2026-06-09-finalized-polygon-draft-clear.md",
    "docs/plans/2026-06-09-make-gate-aliases.md",
    "docs/plans/2026-06-09-cancelled-touch-draft-reset.md",
    "docs/plans/2026-06-09-beginning-polygon-draft-reset.md",
    "docs/plans/2026-06-09-plist-target-metadata.md",
    "docs/plans/2026-06-10-map-view-delegate-outlet.md",
    "docs/plans/2026-06-10-touch-input-map-outlet.md",
    HOSTED_VALIDATION_PLAN,
    SIGNING_METADATA_PLAN,
    INVALID_COORDINATES_PLAN,
    DISTINCT_COORDINATES_PLAN,
    "scripts/check-baseline.py",
    "screenshots/001.png",
]


def read(path):
    return (ROOT / path).read_text(encoding="utf-8", errors="replace")


def markdown_section(text, heading):
    match = re.search(
        rf"(?ms)^## {re.escape(heading)}\s*$\n(.*?)(?=^## |\Z)",
        text,
    )
    return match.group(1).strip() if match else ""


def main():
    failures = []
    for path in REQUIRED:
        if not (ROOT / path).is_file():
            failures.append(f"required file missing: {path}")

    makefile = read("Makefile")
    for phrase in [
        "python3 scripts/check-baseline.py",
        "check: verify",
        "verify: static-check",
        "lint: static-check",
        "test: static-check",
        "build: static-check",
    ]:
        if phrase not in makefile:
            failures.append(f"Makefile must include {phrase}")

    workflow = read(".github/workflows/check.yml")
    codeowners = read(".github/CODEOWNERS")
    for expected in [
        "permissions:\n  contents: read",
        "cancel-in-progress: true",
        "runs-on: macos-15",
        "timeout-minutes: 10",
        "actions/checkout@df4cb1c069e1874edd31b4311f1884172cec0e10",
        "persist-credentials: false",
        "actions/setup-python@a309ff8b426b58ec0e2a45f0f869d46889d02405",
        'python-version: "3.12"',
        "run: make check",
    ]:
        if expected not in workflow:
            failures.append(f"Check workflow must keep {expected}")
    if workflow.count("actions/checkout@") != 1:
        failures.append("Check workflow must use exactly one checkout action")
    if workflow.count("persist-credentials:") != 1:
        failures.append("Check workflow must set checkout credential persistence exactly once")
    if workflow.count("persist-credentials: false") != 1:
        failures.append("Check workflow must disable checkout credential persistence")
    workflow_files = sorted(
        str(path.relative_to(ROOT))
        for path in (ROOT / ".github/workflows").rglob("*")
        if path.is_file()
    )
    if workflow_files != [".github/workflows/check.yml"]:
        failures.append("check.yml must be the repository's only hosted workflow")
    if codeowners.strip() != "* @garethpaul":
        failures.append("CODEOWNERS must assign the repository to @garethpaul")

    gitignore = read(".gitignore")
    for phrase in [
        "DerivedData/",
        "xcuserdata/",
        "*.xcuserstate",
        ".env",
        "*.log",
        "tmp/",
    ]:
        if phrase not in gitignore:
            failures.append(f".gitignore must include {phrase}")

    plists = {}
    for path in [
        "PlaceShapes/Info.plist",
        "PlaceShapesTests/Info.plist",
        "PlaceShapes.xcodeproj/xcuserdata/gpj.xcuserdatad/xcschemes/xcschememanagement.plist",
    ]:
        try:
            with (ROOT / path).open("rb") as handle:
                plists[path] = plistlib.load(handle)
        except Exception as error:
            failures.append(f"{path} must parse as a plist: {error}")
    expected_package_types = {
        "PlaceShapes/Info.plist": "FMWK",
        "PlaceShapesTests/Info.plist": "BNDL",
    }
    for path, package_type in expected_package_types.items():
        plist = plists.get(path)
        if not plist:
            continue
        bundle_identifier = str(plist.get("CFBundleIdentifier", "")).strip()
        if bundle_identifier != "$(PRODUCT_BUNDLE_IDENTIFIER)":
            failures.append(f"{path} must use PRODUCT_BUNDLE_IDENTIFIER for CFBundleIdentifier")
        if plist.get("CFBundlePackageType") != package_type:
            failures.append(f"{path} must keep CFBundlePackageType={package_type}")

    for path in [
        "PlaceShapes.xcodeproj/project.xcworkspace/contents.xcworkspacedata",
        "PlaceShapes.xcodeproj/xcuserdata/gpj.xcuserdatad/xcschemes/PlaceShapes.xcscheme",
        "docs/readme-overview.svg",
    ]:
        try:
            ET.parse(ROOT / path)
        except ET.ParseError as error:
            failures.append(f"{path} must parse as XML: {error}")

    if (ROOT / "screenshots/001.png").read_bytes()[:8] != b"\x89PNG\r\n\x1a\n":
        failures.append("screenshots/001.png must remain a PNG image")

    podfile = read("Podfile")
    for phrase in ["platform :ios, '10.1'", "target 'PlaceShapes'", "target 'PlaceShapesTests'", "use_frameworks!"]:
        if phrase not in podfile:
            failures.append(f"Podfile must include {phrase}")
    if re.search(r"^\s*pod\s+['\"]", podfile, re.MULTILINE):
        failures.append("Podfile should not add third-party pods without updating the baseline")

    pbxproj = read("PlaceShapes.xcodeproj/project.pbxproj")
    signing_settings = []
    for line in pbxproj.splitlines():
        match = re.match(
            r'^\s*"?([A-Z][A-Z0-9_]*)(?:\[[^]]+\])?"?\s*=\s*(.*?);\s*$',
            line,
        )
        if match:
            signing_settings.append(match.groups())
    forbidden_signing_settings = {
        "CODE_SIGN_ENTITLEMENTS",
        "DEVELOPMENT_TEAM",
        "PROVISIONING_PROFILE",
        "PROVISIONING_PROFILE_SPECIFIER",
    }
    present_forbidden_settings = sorted(
        name for name, _ in signing_settings if name in forbidden_signing_settings
    )
    if present_forbidden_settings:
        failures.append(
            "Xcode project must not contain account-specific signing settings: "
            + ", ".join(present_forbidden_settings)
        )
    signing_identities = [
        value for name, value in signing_settings if name == "CODE_SIGN_IDENTITY"
    ]
    expected_signing_identities = [
        '"iPhone Developer"',
        '"iPhone Developer"',
        '""',
        '""',
    ]
    if signing_identities != expected_signing_identities:
        failures.append(
            "Xcode project must retain only its two generic and two empty "
            "signing identities"
        )
    for phrase in [
        "PlaceShapes.framework",
        "PlaceShapesTests.xctest",
        "PlaceShapes.swift",
        "PlaceShapesTests.swift",
        "SWIFT_VERSION = 3.0",
        "IPHONEOS_DEPLOYMENT_TARGET = 10.1",
    ]:
        if phrase not in pbxproj:
            failures.append(f"project.pbxproj must reference {phrase}")

    swift = read("PlaceShapes/PlaceShapes.swift")
    tests = read("PlaceShapesTests/PlaceShapesTests.swift")
    for phrase in [
        "MKMapViewDelegate",
        "MKPolygonRenderer",
        "shouldRenderPolygon(coordinateCount:",
        "static func shouldRenderPolygon(coordinates:",
        "CLLocationCoordinate2DIsValid(coordinate)",
        "static func hasAtLeastThreeDistinctCoordinates(_ coordinates:",
        "return hasAtLeastThreeDistinctCoordinates(coordinates)",
        "existingCoordinate.latitude == coordinate.latitude",
        "existingCoordinate.longitude == coordinate.longitude",
        "if distinctCoordinates.count == 3",
        "func beginPolygonDraft()",
        "func cancelPolygonDraft()",
        "func mapViewForTouchInput() -> MKMapView?",
        "guard let touchMapView = mapView else",
        "guard let touchMapView = mapView else {\n            cancelPolygonDraft()\n            return nil",
        "func finalizePolygonDraft() -> MKPolygon?",
        "mapView?.delegate = self",
        "coordinates.count",
        "guard PlaceShapes.shouldRenderPolygon",
        "guard PlaceShapes.shouldRenderPolygon(coordinates: coordinates)",
        "guard let nextPolygon = finalizePolygonDraft()",
        "touchMapView.remove(polygon)",
        "touchMapView.add(polygon)",
        "var draftCoordinates = coordinates",
        "mapView?.isUserInteractionEnabled",
        "cancelPolygonDraft()",
        "touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {\n        cancelPolygonDraft()",
    ]:
        if phrase not in swift:
            failures.append(f"PlaceShapes.swift must include {phrase}")
    if swift.count("guard let touchMapView = mapViewForTouchInput() else") != 3:
        failures.append("all three active touch callbacks must guard the map view outlet")
    coordinate_validation_source = swift[
        swift.find("static func shouldRenderPolygon(coordinates:"):
        swift.find("func beginPolygonDraft()")
    ]
    validation_markers = [
        "CLLocationCoordinate2DIsValid(coordinate)",
        "return hasAtLeastThreeDistinctCoordinates(coordinates)",
        "static func hasAtLeastThreeDistinctCoordinates",
        "if distinctCoordinates.count == 3",
    ]
    if any(marker not in coordinate_validation_source for marker in validation_markers) or not all(
        coordinate_validation_source.find(left)
        < coordinate_validation_source.find(right)
        for left, right in zip(validation_markers, validation_markers[1:])
    ):
        failures.append(
            "polygon validation must check coordinate ranges before requiring three distinct points"
        )
    for phrase in [
        "testPolygonRenderingRequiresAtLeastThreeCoordinates",
        "testPolygonRenderingRejectsNegativeCoordinateCounts",
        "XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinateCount: -1))",
        "XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinateCount: 2))",
        "XCTAssertTrue(PlaceShapes.shouldRenderPolygon(coordinateCount: 3))",
        "testPolygonRenderingAcceptsValidCoordinates",
        "XCTAssertTrue(PlaceShapes.shouldRenderPolygon(coordinates: coordinates))",
        "testPolygonRenderingRejectsInvalidLatitude",
        "CLLocationCoordinate2D(latitude: 91.0, longitude: -122.1)",
        "testPolygonRenderingRejectsInvalidLongitude",
        "CLLocationCoordinate2D(latitude: 37.1, longitude: 181.0)",
        "testPolygonRenderingAcceptsThreeDistinctCoordinatesWithDuplicateEntry",
        "testPolygonRenderingRejectsOnlyTwoDistinctCoordinates",
        "testPolygonRenderingRejectsOneRepeatedCoordinate",
        "XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinates: coordinates))",
        "testBeginningPolygonDraftClearsCoordinates",
        "controller.beginPolygonDraft()",
        "testCancellingPolygonDraftClearsCoordinates",
        "controller.cancelPolygonDraft()",
        "testLeavingEditingClearsPolygonDraftCoordinates",
        "controller.setEditing(false, animated: false)",
        "testInvalidPolygonFinalizationClearsDraftCoordinates",
        "XCTAssertNil(controller.finalizePolygonDraft())",
        "testSuccessfulPolygonFinalizationClearsDraftCoordinates",
        "XCTAssertNotNil(controller.finalizePolygonDraft())",
        "testInvalidCoordinateFinalizationClearsDraftCoordinates",
        "testCancelledTouchesClearDraftCoordinatesOutsideEditing",
        "controller.touchesCancelled(Set<UITouch>(), with: nil)",
        "testUnavailableTouchInputMapClearsDraftCoordinates",
        "XCTAssertNil(controller.mapViewForTouchInput())",
    ]:
        if phrase not in tests:
            failures.append(f"PlaceShapesTests.swift must include {phrase}")
    if "testExample" in tests or "testPerformanceExample" in tests:
        failures.append("placeholder XCTest methods must be replaced")

    source_text = "\n".join(read(path) for path in [
        "PlaceShapes/PlaceShapes.swift",
        "PlaceShapesTests/PlaceShapesTests.swift",
    ])
    for forbidden in [
        "URLSession",
        "NSURLConnection",
        "CLLocationManager",
        "requestWhenInUseAuthorization",
        "requestAlwaysAuthorization",
        "showsUserLocation = true",
        "http://",
        "https://",
        "Analytics",
        "BEGIN PRIVATE KEY",
    ]:
        if forbidden in source_text:
            failures.append(f"sample must not add network, location upload, analytics, or secrets: {forbidden}")

    docs = "\n".join(read(path) for path in ["README.md", "SECURITY.md", "VISION.md"])
    for phrase in [
        "make check",
        "make lint",
        "make test",
        "make build",
        "make verify",
        "MapKit",
        "local by default",
        "coordinates",
        "Swift 3",
        "CocoaPods",
        "non-placeholder XCTest",
        "cancelled touches",
        "cancelled touch callbacks",
        "starting polygon drafts",
        "leaving edit mode",
        "finalized polygon drafts",
        "CocoaPods platform matches the iOS 10.1 deployment target",
        "plist bundle identifiers",
        "plist package types",
        "map view delegate outlet",
        "touch input map outlet",
        "hosted macOS",
        "credential-free signing metadata",
        "structural validation",
        "CLLocationCoordinate2DIsValid",
        "out-of-range",
        "three distinct",
    ]:
        if phrase.lower() not in docs.lower():
            failures.append(f"docs must mention {phrase}")

    distinct_coordinate_claims = {
        "README.md": "requires at least three distinct valid coordinates",
        "SECURITY.md": "require at least three distinct valid coordinates",
        "VISION.md": "fewer than three distinct coordinates",
        "CHANGES.md": "fewer than three distinct valid coordinates",
    }
    for path, phrase in distinct_coordinate_claims.items():
        if phrase not in " ".join(read(path).split()):
            failures.append(f"{path} must include {phrase}")

    plan = read(PLAN)
    if "status: completed" not in plan or "make check" not in plan:
        failures.append("plan must record completed status and verification")
    test_plan = read("docs/plans/2026-06-09-non-placeholder-xctest.md")
    if "status: completed" not in test_plan or "testPolygonRenderingRejectsNegativeCoordinateCounts" not in test_plan:
        failures.append("XCTest plan must record completed status and verification")
    cancel_plan = read("docs/plans/2026-06-09-cancelled-polygon-drafts.md")
    if "status: completed" not in cancel_plan or "cancelPolygonDraft" not in cancel_plan:
        failures.append("cancelled draft plan must record completed status and verification")
    edit_plan = read("docs/plans/2026-06-09-edit-mode-draft-reset.md")
    if "status: completed" not in edit_plan or "setEditing(false" not in edit_plan:
        failures.append("edit mode draft reset plan must record completed status and verification")
    podfile_plan = read("docs/plans/2026-06-09-podfile-deployment-target.md")
    if "status: completed" not in podfile_plan or "platform :ios, '10.1'" not in podfile_plan:
        failures.append("Podfile deployment target plan must record completed status and verification")
    finalized_plan = read("docs/plans/2026-06-09-finalized-polygon-draft-clear.md")
    if "status: completed" not in finalized_plan or "finalizePolygonDraft" not in finalized_plan:
        failures.append("finalized polygon draft plan must record completed status and verification")
    make_gates_plan = read("docs/plans/2026-06-09-make-gate-aliases.md")
    for phrase in ["status: completed", "make lint", "make test", "make build", "make verify"]:
        if phrase not in make_gates_plan:
            failures.append(f"make gate alias plan must record {phrase}")
    touch_cancel_plan = read("docs/plans/2026-06-09-cancelled-touch-draft-reset.md")
    if "status: completed" not in touch_cancel_plan or "touchesCancelled" not in touch_cancel_plan:
        failures.append("cancelled touch draft reset plan must record completed status and verification")
    begin_draft_plan = read("docs/plans/2026-06-09-beginning-polygon-draft-reset.md")
    if "status: completed" not in begin_draft_plan or "beginPolygonDraft" not in begin_draft_plan:
        failures.append("beginning polygon draft reset plan must record completed status and verification")
    plist_target_plan = read("docs/plans/2026-06-09-plist-target-metadata.md")
    if "status: completed" not in plist_target_plan or "CFBundlePackageType" not in plist_target_plan:
        failures.append("plist target metadata plan must record completed status and verification")
    map_view_delegate_plan = read("docs/plans/2026-06-10-map-view-delegate-outlet.md")
    if (
        "status: completed" not in map_view_delegate_plan
        or "map view delegate outlet" not in map_view_delegate_plan
    ):
        failures.append("map view delegate outlet plan must record completed status and verification")
    touch_input_map_plan = read("docs/plans/2026-06-10-touch-input-map-outlet.md")
    if "status: completed" not in touch_input_map_plan or "mapViewForTouchInput" not in touch_input_map_plan:
        failures.append("touch input map outlet plan must record completed status and verification")
    hosted_validation_plan = read(HOSTED_VALIDATION_PLAN)
    hosted_validation_status = re.findall(
        r"(?mi)^status:\s*(.+?)\s*$", hosted_validation_plan
    )
    hosted_validation_work = markdown_section(hosted_validation_plan, "Work Completed")
    hosted_validation_verification = markdown_section(
        hosted_validation_plan, "Verification Completed"
    )
    if hosted_validation_status != ["completed"] or not hosted_validation_work:
        failures.append(
            "hosted structural validation plan must record one completed status and completed work"
        )
    if not hosted_validation_verification or re.search(
        r"(?i)\b(?:pending|todo|tbd|not run)\b", hosted_validation_verification
    ):
        failures.append(
            "hosted structural validation plan must record finished verification without pending markers"
        )
    for evidence in [
        "make lint",
        "make test",
        "make build",
        "make verify",
        "make check",
        "python3 -W error scripts/check-baseline.py",
        "git diff --check",
        "Five hostile workflow and ownership mutations",
        "27390781674",
        "27390782458",
        "8fb27207d644485cba7795a186c0132261608dc6",
        "df4cb1c069e1874edd31b4311f1884172cec0e10",
        "a309ff8b426b58ec0e2a45f0f869d46889d02405",
        "persist-credentials: false",
        "* @garethpaul",
        "repository's only hosted workflow",
    ]:
        if evidence not in hosted_validation_verification:
            failures.append(
                f"hosted structural validation plan must preserve verification evidence: {evidence}"
            )

    signing_metadata_plan = read(SIGNING_METADATA_PLAN)
    for phrase in [
        "status: completed",
        "make check",
        "six hostile mutations",
        "DEVELOPMENT_TEAM",
        "PROVISIONING_PROFILE_SPECIFIER",
        "CODE_SIGN_ENTITLEMENTS",
    ]:
        if phrase not in signing_metadata_plan:
            failures.append(
                f"credential-free signing metadata plan must record {phrase}"
            )

    invalid_coordinates_plan = read(INVALID_COORDINATES_PLAN)
    invalid_coordinates_status = re.findall(
        r"(?mi)^status:\s*(.+?)\s*$", invalid_coordinates_plan
    )
    invalid_coordinates_work = markdown_section(
        invalid_coordinates_plan, "Work Completed"
    )
    invalid_coordinates_verification = markdown_section(
        invalid_coordinates_plan, "Verification Completed"
    )
    if invalid_coordinates_status != ["completed"] or not invalid_coordinates_work:
        failures.append(
            "invalid polygon coordinates plan must record one completed status and completed work"
        )
    if not invalid_coordinates_verification or re.search(
        r"(?i)\b(?:pending|todo|tbd|not run)\b", invalid_coordinates_verification
    ):
        failures.append(
            "invalid polygon coordinates plan must record completed verification"
        )
    for evidence in [
        "make lint",
        "make test",
        "make build",
        "make verify",
        "make check",
        "external working directory",
        "workflow YAML",
        "plist and workspace XML",
        "README SVG",
        "hostile mutations rejected",
        "git diff --check",
        "secret, personal-coordinate, and generated-artifact scan",
    ]:
        if evidence not in invalid_coordinates_verification:
            failures.append(
                f"invalid polygon coordinates verification must record {evidence}"
            )

    distinct_coordinates_plan = read(DISTINCT_COORDINATES_PLAN)
    distinct_coordinates_status = re.findall(
        r"(?mi)^status:\s*(.+?)\s*$", distinct_coordinates_plan
    )
    distinct_coordinates_work = markdown_section(
        distinct_coordinates_plan, "Work Completed"
    )
    distinct_coordinates_verification = markdown_section(
        distinct_coordinates_plan, "Verification Completed"
    )
    if distinct_coordinates_status != ["completed"] or not distinct_coordinates_work:
        failures.append(
            "distinct polygon coordinates plan must record completed status and work"
        )
    if not distinct_coordinates_verification or re.search(
        r"(?i)\b(?:pending|todo|tbd|not run)\b", distinct_coordinates_verification
    ):
        failures.append(
            "distinct polygon coordinates plan must record completed verification"
        )
    for evidence in [
        "make lint",
        "make test",
        "make build",
        "make verify",
        "make check",
        "external working directory",
        "workflow YAML",
        "plist and workspace XML",
        "README SVG",
        "hostile mutations",
        "git diff --check",
        "secret, personal-coordinate, and generated-artifact scan",
    ]:
        if evidence not in distinct_coordinates_verification:
            failures.append(
                f"distinct polygon coordinates verification must record {evidence}"
            )

    if failures:
        for failure in failures:
            print(failure, file=sys.stderr)
        return 1

    print("placeshapes-ios baseline checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
