#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION=${DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE:-2024}
if [[ "$VERSION" != "2024" ]]; then
    echo "Symbols supports release 2024." >&2
    exit 1
fi
FRAMEWORK_ROOT="$SCRIPT_DIR/$VERSION"
OUTPUT_ROOT="$FRAMEWORK_ROOT/Symbols.xcframework"
SOURCE_MODULES="$FRAMEWORK_ROOT/Sources/Modules/Symbols.swiftmodule"

write_interface() {
    local modules="$1"
    local name="$2"
    local target="$3"
    local output="$modules/$name.swiftinterface"
    cat > "$output" <<HEADER
// swift-interface-format-version: 1.0
// swift-compiler-version: Apple Swift version 6.1.2 effective-5.10 (swiftlang-6.1.2.1.2 clang-1700.0.13.5)
// swift-module-flags: -target $target -enable-objc-interop -enable-library-evolution -swift-version 5 -enforce-exclusivity=checked -O -library-level api -enable-experimental-feature DebugDescriptionMacro -enable-bare-slash-regex -user-module-version 167.5.0.2 -module-name Symbols
// swift-module-flags-ignorable: -interface-compiler-version 6.1.2
HEADER
    cat "$SOURCE_MODULES/template.swiftinterface" >> "$output"
    cp "$output" "$modules/$name.private.swiftinterface"
    printf '\n' >> "$modules/$name.private.swiftinterface"
    cat "$SOURCE_MODULES/template.private.swiftinterface" >> "$modules/$name.private.swiftinterface"
}

generate_framework() {
    local slice="$1"
    local framework="$OUTPUT_ROOT/$slice/Symbols.framework"
    local contents="$framework"
    if [[ "$slice" == macos-* ]]; then
        contents="$framework/Versions/A"
        mkdir -p "$contents/Resources"
        cp "$FRAMEWORK_ROOT/Sources/Info.plist" "$contents/Resources/Info.plist"
        ln -sfn A "$framework/Versions/Current"
        ln -sfn Versions/Current/Headers "$framework/Headers"
        ln -sfn Versions/Current/Modules "$framework/Modules"
        ln -sfn Versions/Current/Resources "$framework/Resources"
        ln -sfn Versions/Current/Symbols.tbd "$framework/Symbols.tbd"
    else
        mkdir -p "$contents"
        cp "$FRAMEWORK_ROOT/Sources/Info.plist" "$contents/Info.plist"
    fi
    cp "$FRAMEWORK_ROOT/tbds/$slice/Symbols.tbd" "$contents/Symbols.tbd"
    cp -R "$FRAMEWORK_ROOT/Sources/Headers" "$contents/Headers"
    local modules="$contents/Modules/Symbols.swiftmodule"
    mkdir -p "$modules"
    cp "$FRAMEWORK_ROOT/Sources/Modules/module.modulemap" "$contents/Modules/module.modulemap"
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
                write_interface "$modules" "$arch-apple-ios-simulator" "$arch-apple-ios18.0-simulator"
            done
            ;;
        xros-arm64-x86_64-simulator)
            for arch in arm64 x86_64; do
                write_interface "$modules" "$arch-apple-xros-simulator" "$arch-apple-xros2.0-simulator"
            done
            ;;
        xros-arm64-arm64e)
            for arch in arm64 arm64e; do
                write_interface "$modules" "$arch-apple-xros" "$arch-apple-xros2.0"
            done
            ;;
    esac
}

rm -rf "$OUTPUT_ROOT"
mkdir -p "$OUTPUT_ROOT"
cp "$FRAMEWORK_ROOT/Info.plist" "$OUTPUT_ROOT/Info.plist"
generate_framework macos-arm64e-arm64-x86_64
generate_framework ios-arm64-arm64e
generate_framework ios-arm64-x86_64-simulator
generate_framework xros-arm64-x86_64-simulator
generate_framework xros-arm64-arm64e
