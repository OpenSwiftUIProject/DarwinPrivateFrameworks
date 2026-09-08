#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION=${DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE:-2024}
if [[ "$VERSION" != "2024" ]]; then
    echo "FeatureFlags supports release 2024." >&2
    exit 1
fi
FRAMEWORK_ROOT="$SCRIPT_DIR/$VERSION"
OUTPUT_ROOT="$FRAMEWORK_ROOT/FeatureFlags.xcframework"

write_interface() {
    local modules="$1"
    local name="$2"
    local target="$3"
    local output="$modules/$name.swiftinterface"
    cat > "$output" <<HEADER
// swift-interface-format-version: 1.0
// swift-compiler-version: Apple Swift version 6.1
// swift-module-flags: -target $target -enable-objc-interop -enable-library-evolution -swift-version 5 -module-name FeatureFlags
HEADER
    cat "$FRAMEWORK_ROOT/Sources/Modules/FeatureFlags.swiftmodule/template.swiftinterface" >> "$output"
}

generate_framework() {
    local slice="$1"
    local framework="$OUTPUT_ROOT/$slice/FeatureFlags.framework"
    local contents="$framework"
    if [[ "$slice" == macos-* ]]; then
        contents="$framework/Versions/A"
        mkdir -p "$contents/Resources"
        cp "$FRAMEWORK_ROOT/Sources/Info.plist" "$contents/Resources/Info.plist"
        ln -sfn A "$framework/Versions/Current"
        ln -sfn Versions/Current/Modules "$framework/Modules"
        ln -sfn Versions/Current/Resources "$framework/Resources"
        ln -sfn Versions/Current/FeatureFlags.tbd "$framework/FeatureFlags.tbd"
    else
        mkdir -p "$contents"
        cp "$FRAMEWORK_ROOT/Sources/Info.plist" "$contents/Info.plist"
    fi
    cp "$FRAMEWORK_ROOT/tbds/$slice/FeatureFlags.tbd" "$contents/FeatureFlags.tbd"
    local modules="$contents/Modules/FeatureFlags.swiftmodule"
    mkdir -p "$modules"
    case "$slice" in
        macos-*)
            for arch in arm64 arm64e x86_64; do
                write_interface "$modules" "$arch-apple-macos" "$arch-apple-macos15.0"
            done
            ;;
        ios-arm64-arm64e)
            for arch in arm64 arm64e; do
                write_interface "$modules" "$arch-apple-ios" "$arch-apple-ios18.0"
            done
            ;;
        ios-arm64-x86_64-simulator)
            for arch in arm64 x86_64; do
                write_interface "$modules" "$arch-apple-ios-simulator" "$arch-apple-ios18.5-simulator"
            done
            ;;
    esac
}

mkdir -p "$OUTPUT_ROOT"
cp "$FRAMEWORK_ROOT/Info.plist" "$OUTPUT_ROOT/Info.plist"
generate_framework macos-arm64e-arm64-x86_64
generate_framework ios-arm64-arm64e
generate_framework ios-arm64-x86_64-simulator
