#!/bin/bash

set -e

# Function to display usage
usage() {
    echo "Usage: $0 <sdk_path>"
    echo "  sdk_path: Path to XRSimulator.Internal.sdk"
    echo ""
    echo "This script enables UIScreen support in visionOS SDK by:"
    echo "  - Removing ALL API_UNAVAILABLE restrictions containing visionos from UIScreen.h"
    echo "  - Removing API_UNAVAILABLE restrictions from UIWindow.screen property"
    exit 1
}

# Check arguments
if [ $# -lt 1 ]; then
    usage
fi

SDK_PATH="$1"

# Validate SDK path
if [ ! -d "$SDK_PATH" ]; then
    echo "Error: SDK path does not exist: $SDK_PATH"
    exit 1
fi

# UIKit framework path
UIKIT_PATH="$SDK_PATH/System/Library/Frameworks/UIKit.framework"

if [ ! -d "$UIKIT_PATH" ]; then
    echo "Error: UIKit framework not found at: $UIKIT_PATH"
    exit 1
fi

echo "Enabling UIScreen support in visionOS SDK at: $SDK_PATH"

# Process UIScreen.h - Remove ALL visionOS restrictions
UISCREEN_H="$UIKIT_PATH/Headers/UIScreen.h"
if [ -f "$UISCREEN_H" ]; then
    echo "  Processing UIScreen.h..."

    # Create backup
    cp "$UISCREEN_H" "${UISCREEN_H}.backup"

    # Create temporary file for processing
    temp_file="${UISCREEN_H}.tmp"

    # Remove all visionOS restrictions from UIScreen.h
    # 1. Remove standalone API_UNAVAILABLE(visionos)
    # 2. Change API_UNAVAILABLE(visionos, xxx) to API_UNAVAILABLE(xxx)
    # 3. Handle cases where visionos is first in the list
    # 4. Handle cases where visionos is in the middle or end of the list
    sed -E \
        -e 's/[[:space:]]+API_UNAVAILABLE\(visionos\)[[:space:]]*;/;/g' \
        -e 's/[[:space:]]+API_UNAVAILABLE\(visionos\)([^;])/\1/g' \
        -e 's/API_UNAVAILABLE\(visionos,[[:space:]]*/API_UNAVAILABLE(/g' \
        -e 's/API_UNAVAILABLE\(([^,)]+),[[:space:]]*visionos[[:space:]]*\)/API_UNAVAILABLE(\1)/g' \
        -e 's/API_UNAVAILABLE\(([^,)]+),[[:space:]]*visionos,[[:space:]]*([^)]+)\)/API_UNAVAILABLE(\1, \2)/g' \
        -e 's/API_UNAVAILABLE\(([^)]*)[[:space:]]*,[[:space:]]*visionos\)/API_UNAVAILABLE(\1)/g' \
        "$UISCREEN_H" > "$temp_file"

    # Move processed file back
    mv "$temp_file" "$UISCREEN_H"

    echo "    Removed ALL visionos restrictions from UIScreen.h"
else
    echo "  Warning: UIScreen.h not found"
fi

# Process UIWindow.h - Only remove restriction from screen property
UIWINDOW_H="$UIKIT_PATH/Headers/UIWindow.h"
if [ -f "$UIWINDOW_H" ]; then
    echo "  Processing UIWindow.h..."

    # Create backup
    cp "$UIWINDOW_H" "${UIWINDOW_H}.backup"

    # Remove API_UNAVAILABLE(visionos) from screen property only
    # This changes line like:
    # @property(nonatomic,strong) UIScreen *screen API_AVAILABLE(ios(3.2)) API_UNAVAILABLE(visionos);
    # to:
    # @property(nonatomic,strong) UIScreen *screen API_AVAILABLE(ios(3.2));
    sed -i '' -E \
        's/(@property\(nonatomic,strong\) UIScreen \*screen API_AVAILABLE\(ios\(3\.2\)\)) API_UNAVAILABLE\(visionos\);/\1;/g' \
        "$UIWINDOW_H"

    echo "    Removed visionos restriction from UIWindow.screen property"
else
    echo "  Warning: UIWindow.h not found"
fi

echo ""
echo "Successfully enabled UIScreen support in visionOS SDK"
echo "Backup files created with .backup extension"
echo ""
echo "Note: The following changes were made:"
echo "  - ALL UIScreen APIs are now available on visionOS (including UIScreenOverscanCompensation, etc.)"
echo "  - UIWindow.screen property is now available on visionOS"
echo "  - Other UIKit APIs retain their visionOS restrictions"