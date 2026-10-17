#!/bin/bash
#
# Legacy entry point used by Scripts/SDK/install_internal_sdk.sh XRSimulator.
# It patches the UIKit headers of an internal SDK copy in place.
# New integrations use Scripts/XR/install_xr_uikit_overlay.sh instead.

set -euo pipefail

usage() {
    echo "Usage: $0 <sdk_path>"
    echo "  sdk_path: Path to a writable XRSimulator SDK copy, for example XRSimulator.Internal.sdk"
    echo ""
    echo "Removes the visionOS restrictions from UIScreen.h, UIWindow.screen, and UIDevice.orientation in that SDK."
}

if [[ $# -ne 1 ]]; then
    usage >&2
    exit 1
fi

SDK_PATH="$1"
HEADERS_DIR="$SDK_PATH/System/Library/Frameworks/UIKit.framework/Headers"

if [[ ! -d "$HEADERS_DIR" ]]; then
    echo "Error: UIKit headers not found at: $HEADERS_DIR" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec "$SCRIPT_DIR/patch_uikit_headers.sh" "$HEADERS_DIR"
