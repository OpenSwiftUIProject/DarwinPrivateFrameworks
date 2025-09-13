#!/bin/bash

set -e

# Function to display usage
usage() {
    echo "Usage: $0 <sdk_path>"
    echo "  sdk_path: Path to XRSimulator.Internal.sdk"
    echo ""
    echo "This script removes API_UNAVAILABLE(visionos) restrictions from UIScreen and related APIs"
    echo "to enable UIScreen support in visionOS SDK."
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

# Function to process a header file
process_header() {
    local header_file="$1"
    local header_name=$(basename "$header_file")

    if [ ! -f "$header_file" ]; then
        echo "  Warning: $header_name not found, skipping"
        return
    fi

    echo "  Processing $header_name..."

    # Create backup
    cp "$header_file" "${header_file}.backup"

    # Create temporary file for processing
    local temp_file="${header_file}.tmp"

    # Process the file with multiple sed operations
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
        "$header_file" > "$temp_file"

    # Move processed file back
    mv "$temp_file" "$header_file"

    echo "    Done processing $header_name"
}

# List of headers to process for UIScreen support
HEADERS_TO_PROCESS=(
    "Headers/UIScreen.h"
    "Headers/UIWindow.h"
    "Headers/UIApplication.h"
    "Headers/UIScene.h"
    "Headers/UIWindowScene.h"
    "Headers/UIScreenMode.h"
    "Headers/UIView.h"
    "Headers/UIViewController.h"
)

# Process each header file
for header in "${HEADERS_TO_PROCESS[@]}"; do
    header_path="$UIKIT_PATH/$header"
    process_header "$header_path"
done

# Also process module map if it exists
MODULE_MAP="$UIKIT_PATH/Modules/module.modulemap"
if [ -f "$MODULE_MAP" ]; then
    echo "  Processing module.modulemap..."
    cp "$MODULE_MAP" "${MODULE_MAP}.backup"
    # Remove any visionos specific exclusions if they exist
    sed -i '' -E \
        -e 's/[[:space:]]*&&[[:space:]]*!os\(visionOS\)//g' \
        -e 's/!os\(visionOS\)[[:space:]]*&&[[:space:]]*//g' \
        "$MODULE_MAP"
    echo "    Done processing module.modulemap"
fi

echo ""
echo "Successfully enabled UIScreen support in visionOS SDK"
echo "Backup files created with .backup extension"