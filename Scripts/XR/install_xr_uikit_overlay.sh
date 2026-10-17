#!/bin/bash
#
# Generate a clang and swift virtual file system overlay that replaces the
# UIScreen.h, UIWindow.h, and UIDevice.h headers of the selected visionOS
# Simulator SDK with copies that allow UIScreen, UIWindow.screen, and
# UIDevice.orientation on visionOS. The SDK inside Xcode stays untouched.
#
# Consume the overlay from a project with:
#   OTHER_CFLAGS[sdk=xrsimulator*] = $(inherited) -ivfsoverlay <output>/overlay.yaml
#   OTHER_SWIFT_FLAGS[sdk=xrsimulator*] = $(inherited) -vfsoverlay <output>/overlay.yaml
#
# With --sdk, the script also writes a UIKit-only additions SDK for projects
# that prefer the ADDITIONAL_SDKS build setting:
#   ADDITIONAL_SDKS[sdk=xrsimulator*] = $(inherited) <output>/XRSimulator.additions.sdk

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH_SCRIPT="$SCRIPT_DIR/patch_uikit_headers.sh"
OUTPUT_DIR="$HOME/Library/Developer/OpenSwiftUI/XRSimulator"
MANIFEST_NAME="manifest.json"
GENERATOR_ID="DarwinPrivateFrameworks/Scripts/XR/install_xr_uikit_overlay.sh"
SDK_NAME="XRSimulator.additions.sdk"
WITH_SDK=0
FORCE=0

usage() {
    echo "Usage: $0 [--output <dir>] [--sdk] [--force]"
    echo "Generate a UIKit header overlay for the selected visionOS Simulator SDK."
    echo ""
    echo "  --output <dir>  Output directory. Default: $OUTPUT_DIR"
    echo "  --sdk           Also write a UIKit-only additions SDK ($SDK_NAME)."
    echo "  --force         Replace an output directory that this script did not create."
    echo ""
    echo "Set DEVELOPER_DIR to select a different Xcode. Run again after switching Xcode."
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --output)
            if [[ $# -lt 2 || -z "$2" ]]; then
                echo "Error: --output needs a directory" >&2
                exit 1
            fi
            OUTPUT_DIR="$2"
            shift
            ;;
        --sdk)
            WITH_SDK=1
            ;;
        --force)
            FORCE=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Error: Unknown argument: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
    shift
done

if [[ "$OUTPUT_DIR" != /* ]]; then
    OUTPUT_DIR="$PWD/$OUTPUT_DIR"
fi
OUTPUT_DIR="${OUTPUT_DIR%/}"
# The output directory is replaced as a whole, so refuse locations that hold other data.
case "$OUTPUT_DIR" in
    ""|/|"$HOME"|"${HOME%/}"|"$PWD"|"${PWD%/}")
        echo "Error: Refusing to use $OUTPUT_DIR as the output directory" >&2
        exit 1
        ;;
esac
if [[ -L "$OUTPUT_DIR" ]]; then
    echo "Error: The output directory must not be a symbolic link: $OUTPUT_DIR" >&2
    exit 1
fi
if [[ ! -x "$PATCH_SCRIPT" ]]; then
    echo "Error: Missing patch script: $PATCH_SCRIPT" >&2
    exit 1
fi

DEVELOPER_DIR_SELECTED="$(xcode-select -p)"
DEVELOPER_DIR_SELECTED="${DEVELOPER_DIR_SELECTED%/}"
BASE_SDK="$(xcrun --sdk xrsimulator --show-sdk-path)"
SDK_VERSION="$(xcrun --sdk xrsimulator --show-sdk-version)"
SDK_BUILD="$(xcrun --sdk xrsimulator --show-sdk-build-version)"
XCODE_BUILD="$(xcodebuild -version | awk '/Build version/ { print $3 }')"
UIKIT_FRAMEWORK="$BASE_SDK/System/Library/Frameworks/UIKit.framework"
PATCHED_HEADERS=(UIScreen.h UIWindow.h UIDevice.h)
for component in "${PATCHED_HEADERS[@]/#/Headers/}" Modules/module.modulemap UIKit.tbd; do
    if [[ ! -f "$UIKIT_FRAMEWORK/$component" ]]; then
        echo "Error: Missing UIKit input: $UIKIT_FRAMEWORK/$component" >&2
        exit 1
    fi
done

owned_output_dir() {
    [[ -f "$OUTPUT_DIR/$MANIFEST_NAME" ]] \
        && grep -q "\"generator\": \"$GENERATOR_ID\"" "$OUTPUT_DIR/$MANIFEST_NAME"
}

if [[ -e "$OUTPUT_DIR" && $FORCE -eq 0 ]] && ! owned_output_dir; then
    echo "Error: $OUTPUT_DIR exists and was not created by this script. Pass --force to replace it." >&2
    exit 1
fi

# The compiler matches overlay roots by the SDK path it was given. Register
# every spelling of the UIKit headers directory that Xcode or xcrun can use.
sdk_dirs=()
add_sdk_dir() {
    local dir="$1"
    local existing
    [[ -d "$dir" ]] || return 0
    for existing in "${sdk_dirs[@]+"${sdk_dirs[@]}"}"; do
        [[ "$existing" == "$dir" ]] && return 0
    done
    sdk_dirs+=("$dir")
}
developer_dirs=("$DEVELOPER_DIR_SELECTED")
if [[ -n "${DEVELOPER_DIR:-}" ]]; then
    developer_dirs+=("${DEVELOPER_DIR%/}")
fi
if [[ -d /Applications/Xcode.app/Contents/Developer ]] \
    && [[ "$(realpath /Applications/Xcode.app/Contents/Developer)" == "$(realpath "$DEVELOPER_DIR_SELECTED")" ]]; then
    developer_dirs+=(/Applications/Xcode.app/Contents/Developer)
fi
for developer_dir in "${developer_dirs[@]}"; do
    add_sdk_dir "$developer_dir/Platforms/XRSimulator.platform/Developer/SDKs/XRSimulator$SDK_VERSION.sdk"
    add_sdk_dir "$developer_dir/Platforms/XRSimulator.platform/Developer/SDKs/XRSimulator.sdk"
done
add_sdk_dir "$BASE_SDK"
add_sdk_dir "$(realpath "$BASE_SDK")"

PARENT_DIR="$(dirname "$OUTPUT_DIR")"
mkdir -p "$PARENT_DIR"
STAGING_DIR="$(mktemp -d "$PARENT_DIR/.xr-uikit-overlay.XXXXXX")"
trap 'rm -rf "$STAGING_DIR"' EXIT
chmod 755 "$STAGING_DIR"

HEADERS_DIR="$STAGING_DIR/UIKit/Headers"
mkdir -p "$HEADERS_DIR"
for header in "${PATCHED_HEADERS[@]}"; do
    cp "$UIKIT_FRAMEWORK/Headers/$header" "$HEADERS_DIR/"
done
chmod u+w "$HEADERS_DIR"/*.h
"$PATCH_SCRIPT" "$HEADERS_DIR"

# Overlay paths must point at the final location, not the staging directory.
FINAL_HEADERS_DIR="$OUTPUT_DIR/UIKit/Headers"
{
    echo '{'
    echo '  "version": 0,'
    echo '  "case-sensitive": "false",'
    echo '  "use-external-names": true,'
    echo '  "roots": ['
    for index in "${!sdk_dirs[@]}"; do
        separator=","
        if [[ $index -eq $((${#sdk_dirs[@]} - 1)) ]]; then
            separator=""
        fi
        echo '    {'
        echo "      \"name\": \"${sdk_dirs[$index]}/System/Library/Frameworks/UIKit.framework/Headers\","
        echo '      "type": "directory",'
        echo '      "contents": ['
        for header_index in "${!PATCHED_HEADERS[@]}"; do
            header="${PATCHED_HEADERS[$header_index]}"
            header_separator=","
            if [[ $header_index -eq $((${#PATCHED_HEADERS[@]} - 1)) ]]; then
                header_separator=""
            fi
            echo "        { \"name\": \"$header\", \"type\": \"file\", \"external-contents\": \"$FINAL_HEADERS_DIR/$header\" }$header_separator"
        done
        echo '      ]'
        echo "    }$separator"
    done
    echo '  ]'
    echo '}'
} > "$STAGING_DIR/overlay.yaml"

if [[ $WITH_SDK -eq 1 ]]; then
    SDK_DIR="$STAGING_DIR/$SDK_NAME"
    SDK_FRAMEWORKS_DIR="$SDK_DIR/System/Library/Frameworks"
    mkdir -p "$SDK_FRAMEWORKS_DIR"
    # Framework search paths do not merge partial header directories, so the
    # additions SDK needs the whole UIKit SDK framework.
    cp -R "$UIKIT_FRAMEWORK" "$SDK_FRAMEWORKS_DIR/"
    chmod -R u+w "$SDK_FRAMEWORKS_DIR/UIKit.framework"
    "$PATCH_SCRIPT" "$SDK_FRAMEWORKS_DIR/UIKit.framework/Headers"
    # Keep a separate prefix so SDK_DIR_xrsimulator stays bound to the base SDK.
    cat > "$SDK_DIR/SDKSettings.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CanonicalName</key>
	<string>DarwinPrivateFrameworks_xrsimulator$SDK_VERSION</string>
	<key>DisplayName</key>
	<string>DarwinPrivateFrameworks visionOS Simulator $SDK_VERSION UIKit Additions</string>
	<key>IsBaseSDK</key>
	<false/>
	<key>FrameworkSearchPaths</key>
	<array>
		<string>System/Library/Frameworks</string>
	</array>
</dict>
</plist>
PLIST
    plutil -lint -s "$SDK_DIR/SDKSettings.plist"
fi

PATCH_SHA256="$(shasum -a 256 "$PATCH_SCRIPT" | cut -d ' ' -f 1)"
cat > "$STAGING_DIR/$MANIFEST_NAME" <<MANIFEST
{
  "generator": "$GENERATOR_ID",
  "generatedAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "developerDir": "$DEVELOPER_DIR_SELECTED",
  "xcodeBuild": "$XCODE_BUILD",
  "baseSDK": "$BASE_SDK",
  "sdkVersion": "$SDK_VERSION",
  "sdkBuild": "$SDK_BUILD",
  "patchScriptSHA256": "$PATCH_SHA256",
  "additionsSDK": $([[ $WITH_SDK -eq 1 ]] && echo true || echo false)
}
MANIFEST

rm -rf "$OUTPUT_DIR"
mv "$STAGING_DIR" "$OUTPUT_DIR"
trap - EXIT

echo "Created UIKit header overlay: $OUTPUT_DIR/overlay.yaml"
echo "Xcode $XCODE_BUILD, XRSimulator SDK $SDK_VERSION ($SDK_BUILD)"
echo ""
echo "Build settings for the consuming project:"
echo "  OTHER_CFLAGS[sdk=xrsimulator*] = \$(inherited) -ivfsoverlay $OUTPUT_DIR/overlay.yaml"
echo "  OTHER_SWIFT_FLAGS[sdk=xrsimulator*] = \$(inherited) -vfsoverlay $OUTPUT_DIR/overlay.yaml"
if [[ $WITH_SDK -eq 1 ]]; then
    echo "Or, with the additions SDK:"
    echo "  ADDITIONAL_SDKS[sdk=xrsimulator*] = \$(inherited) $OUTPUT_DIR/$SDK_NAME"
fi
