#!/bin/bash

set -e

# Function to get absolute path
filepath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

# Function to display usage
usage() {
    echo "Usage: $0 <platform> [xcode_path]"
    echo "  platform: MacOSX, iPhoneSimulator, iPhoneOS, or XRSimulator"
    echo "  xcode_path: Path to Xcode developer directory (optional, defaults to xcode-select -p)"
    echo ""
    echo "This script restores the original SDK configuration from .original backup files"
    echo ""
    echo "Example:"
    echo "  $0 XRSimulator"
    echo "  $0 MacOSX /Applications/Xcode-16.4.0.app/Contents/Developer"
    exit 1
}

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    usage
fi

PLATFORM="$1"
XCODE_PATH="${2:-$(xcode-select -p)}"

# Validate platform
if [ "$PLATFORM" != "MacOSX" ] && [ "$PLATFORM" != "iPhoneSimulator" ] && [ "$PLATFORM" != "iPhoneOS" ] && [ "$PLATFORM" != "XRSimulator" ]; then
    echo "Error: Only MacOSX, iPhoneSimulator, iPhoneOS, and XRSimulator platforms are supported"
    exit 1
fi

# Validate Xcode path
if [ ! -d "$XCODE_PATH" ]; then
    echo "Error: Xcode path does not exist: $XCODE_PATH"
    exit 1
fi

SDK_DIR="$XCODE_PATH/Platforms/$PLATFORM.platform/Developer/SDKs"

if [ ! -d "$SDK_DIR" ]; then
    echo "Error: SDK directory not found: $SDK_DIR"
    exit 1
fi

echo "Restoring original SDK configuration in: $SDK_DIR"
cd "$SDK_DIR"

# Find and restore all .original files
FOUND_ORIGINAL=false
for original_file in *.sdk.original; do
    if [ -f "$original_file" ]; then
        FOUND_ORIGINAL=true
        SDK_NAME="${original_file%.original}"
        ORIGINAL_TARGET=$(cat "$original_file")

        echo "  Restoring $SDK_NAME -> $ORIGINAL_TARGET"

        # Remove the current symlink/file
        rm -f "$SDK_NAME"

        # Recreate the symlink
        ln -sf "$ORIGINAL_TARGET" "$SDK_NAME"

        # Remove the .original file after successful restoration
        rm -f "$original_file"

        echo "    Restored successfully"
    fi
done

if [ "$FOUND_ORIGINAL" = false ]; then
    echo "No .original backup files found in $SDK_DIR"
    echo "The SDK configuration may already be in its original state."
else
    echo ""
    echo "Successfully restored original SDK configuration"
fi

# List current SDK symlinks for verification
echo ""
echo "Current SDK configuration:"
ls -la | grep -E "\.sdk" | grep "^l"