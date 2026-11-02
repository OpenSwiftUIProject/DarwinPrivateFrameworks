#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION=${DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE:-2024}
if [[ "$VERSION" != "2024" ]]; then
    echo "CoreMaterial supports release 2024." >&2
    exit 1
fi
FRAMEWORK_ROOT="$SCRIPT_DIR/$VERSION"
OUTPUT_ROOT="$FRAMEWORK_ROOT/CoreMaterial.xcframework"

generate_framework() {
    local slice="$1"
    local framework="$OUTPUT_ROOT/$slice/CoreMaterial.framework"
    local contents="$framework"
    if [[ "$slice" == macos-* ]]; then
        contents="$framework/Versions/A"
        mkdir -p "$contents/Resources"
        cp "$FRAMEWORK_ROOT/Sources/Info.plist" "$contents/Resources/Info.plist"
        ln -sfn A "$framework/Versions/Current"
        ln -sfn Versions/Current/Headers "$framework/Headers"
        ln -sfn Versions/Current/Modules "$framework/Modules"
        ln -sfn Versions/Current/Resources "$framework/Resources"
        ln -sfn Versions/Current/CoreMaterial.tbd "$framework/CoreMaterial.tbd"
    else
        mkdir -p "$contents"
        cp "$FRAMEWORK_ROOT/Sources/Info.plist" "$contents/Info.plist"
    fi
    # Keep the complete exports and allow clients to link through this package.
    python3 - "$FRAMEWORK_ROOT/tbds/$slice/CoreMaterial.tbd" "$contents/CoreMaterial.tbd" <<'PYTHON'
import json
import sys

source, destination = sys.argv[1:]
with open(source) as file:
    stub = json.load(file)
stub["main_library"].pop("allowable_clients", None)
with open(destination, "w") as file:
    json.dump(stub, file, indent=2)
    file.write("\n")
PYTHON
    cp -R "$FRAMEWORK_ROOT/Sources/Headers" "$contents/Headers"
    cp -R "$FRAMEWORK_ROOT/Sources/Modules" "$contents/Modules"
}

rm -rf "$OUTPUT_ROOT"
mkdir -p "$OUTPUT_ROOT"
cp "$FRAMEWORK_ROOT/Info.plist" "$OUTPUT_ROOT/Info.plist"
generate_framework macos-arm64e-arm64-x86_64
generate_framework ios-arm64-arm64e
generate_framework ios-arm64-x86_64-simulator
generate_framework xros-arm64-arm64e
generate_framework xros-arm64-x86_64-simulator
