#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
derived_data_path=${DERIVED_DATA_PATH:-${TMPDIR:-/tmp}/placeshapes-derived-data}
device_id=$(
    xcrun simctl list devices available -j | python3 -c '
import json
import sys

devices = json.load(sys.stdin).get("devices", {})
for runtime, runtime_devices in devices.items():
    if "SimRuntime.iOS-" not in runtime:
        continue
    for device in runtime_devices:
        if device.get("isAvailable") and device.get("name", "").startswith("iPhone"):
            print(device["udid"])
            raise SystemExit(0)
raise SystemExit("no available iPhone simulator found")
'
)

xcodebuild test \
    -project "$repo_root/PlaceShapes.xcodeproj" \
    -scheme PlaceShapes \
    -destination "platform=iOS Simulator,id=$device_id" \
    -destination-timeout 60 \
    -derivedDataPath "$derived_data_path" \
    CODE_SIGNING_ALLOWED=NO \
    IPHONEOS_DEPLOYMENT_TARGET=12.0 \
    SWIFT_VERSION=5 \
    ONLY_ACTIVE_ARCH=YES
