#!/usr/bin/env python3
"""Static baseline checks for the PlaceShapes iOS MapKit sample."""

from pathlib import Path
import plistlib
import re
import sys
import xml.etree.ElementTree as ET


ROOT = Path(__file__).resolve().parents[1]
PLAN = "docs/plans/2026-06-08-placeshapes-baseline.md"
REQUIRED = [
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
    "scripts/check-baseline.py",
    "screenshots/001.png",
]


def read(path):
    return (ROOT / path).read_text(encoding="utf-8", errors="replace")


def main():
    failures = []
    for path in REQUIRED:
        if not (ROOT / path).is_file():
            failures.append(f"required file missing: {path}")

    makefile = read("Makefile")
    if "python3 scripts/check-baseline.py" not in makefile:
        failures.append("Makefile must expose the static checker")

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

    for path in [
        "PlaceShapes/Info.plist",
        "PlaceShapesTests/Info.plist",
        "PlaceShapes.xcodeproj/xcuserdata/gpj.xcuserdatad/xcschemes/xcschememanagement.plist",
    ]:
        try:
            with (ROOT / path).open("rb") as handle:
                plistlib.load(handle)
        except Exception as error:
            failures.append(f"{path} must parse as a plist: {error}")

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
        "func cancelPolygonDraft()",
        "func finalizePolygonDraft() -> MKPolygon?",
        "coordinates.count",
        "guard PlaceShapes.shouldRenderPolygon",
        "guard let nextPolygon = finalizePolygonDraft()",
        "var draftCoordinates = coordinates",
        "mapView?.isUserInteractionEnabled",
        "cancelPolygonDraft()",
    ]:
        if phrase not in swift:
            failures.append(f"PlaceShapes.swift must include {phrase}")
    for phrase in [
        "testPolygonRenderingRequiresAtLeastThreeCoordinates",
        "testPolygonRenderingRejectsNegativeCoordinateCounts",
        "XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinateCount: -1))",
        "XCTAssertFalse(PlaceShapes.shouldRenderPolygon(coordinateCount: 2))",
        "XCTAssertTrue(PlaceShapes.shouldRenderPolygon(coordinateCount: 3))",
        "testCancellingPolygonDraftClearsCoordinates",
        "controller.cancelPolygonDraft()",
        "testLeavingEditingClearsPolygonDraftCoordinates",
        "controller.setEditing(false, animated: false)",
        "testInvalidPolygonFinalizationClearsDraftCoordinates",
        "XCTAssertNil(controller.finalizePolygonDraft())",
        "testSuccessfulPolygonFinalizationClearsDraftCoordinates",
        "XCTAssertNotNil(controller.finalizePolygonDraft())",
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
        "MapKit",
        "local by default",
        "coordinates",
        "Swift 3",
        "CocoaPods",
        "non-placeholder XCTest",
        "cancelled touches",
        "leaving edit mode",
        "finalized polygon drafts",
        "CocoaPods platform matches the iOS 10.1 deployment target",
    ]:
        if phrase.lower() not in docs.lower():
            failures.append(f"docs must mention {phrase}")

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

    if failures:
        for failure in failures:
            print(failure, file=sys.stderr)
        return 1

    print("placeshapes-ios baseline checks passed.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
