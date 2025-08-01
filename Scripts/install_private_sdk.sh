#!/bin/bash

set -e

# Function to get absolute path
filepath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

# Define repository root
REPO_ROOT=$(filepath "$(dirname "$0")/..")

# Function to display usage
usage() {
    echo "Usage: $0 <platform> [xcode_path] [-f]"
    echo "  platform: MacOSX or iPhoneSimulator"
    echo "  xcode_path: Path to Xcode developer directory (optional, defaults to xcode-select -p)"
    echo "  -f: Force installation (backup existing Internal SDK)"
    echo ""
    echo "Example:"
    echo "  $0 MacOSX"
    echo "  $0 iPhoneSimulator /Applications/Xcode-16.4.0.app/Contents/Developer -f"
    exit 1
}

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    usage
fi

# Parse arguments
PLATFORM="$1"
FORCE_INSTALL=false

# Check if second argument is -f
if [ "$2" = "-f" ]; then
    FORCE_INSTALL=true
    XCODE_PATH="$(xcode-select -p)"
else
    XCODE_PATH="${2:-$(xcode-select -p)}"
    # Check for -f flag in third argument
    if [ "$3" = "-f" ]; then
        FORCE_INSTALL=true
    fi
fi

# Validate platform
if [ "$PLATFORM" != "MacOSX" ] && [ "$PLATFORM" != "iPhoneSimulator" ]; then
    echo "Error: Only MacOSX and iPhoneSimulator platforms are supported"
    exit 1
fi

# FIXME: Traced by #4
if [ "$PLATFORM" == "iPhoneSimulator" ]; then
    echo "[TODO]: iPhoneSimulator has not been implemented yet"
    exit 1
fi

# Validate Xcode path
if [ ! -d "$XCODE_PATH" ]; then    echo "Error: Xcode path does not exist: $XCODE_PATH"
    exit 1
fi

# Construct SDK paths
ORIGINAL_SDK_PATH="$XCODE_PATH/Platforms/$PLATFORM.platform/Developer/SDKs/$PLATFORM.sdk"
INTERNAL_SDK_PATH="$XCODE_PATH/Platforms/$PLATFORM.platform/Developer/SDKs/$PLATFORM.Internal.sdk"

# Check if original SDK exists
if [ ! -d "$ORIGINAL_SDK_PATH" ]; then
    echo "Error: Original SDK not found at: $ORIGINAL_SDK_PATH"
    exit 1
fi

# Check if Internal SDK already exists
if [ -d "$INTERNAL_SDK_PATH" ]; then
    if [ "$FORCE_INSTALL" = false ]; then
        echo "Internal SDK already exists at: $INTERNAL_SDK_PATH"
        echo "Use -f flag to force reinstallation: $0 $PLATFORM -f"
        exit 1
    else
        # Create backup with timestamp
        TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
        BACKUP_PATH="$XCODE_PATH/Platforms/$PLATFORM.platform/Developer/SDKs/$PLATFORM.Internal.sdk_${TIMESTAMP}_backup"
        echo "Backing up existing Internal SDK to: $BACKUP_PATH"
        mv "$INTERNAL_SDK_PATH" "$BACKUP_PATH"
    fi
fi

# Copy original SDK to Internal SDK
echo "Copying SDK from:"
echo "  Source: $ORIGINAL_SDK_PATH"
echo "  Target: $INTERNAL_SDK_PATH"

cp -R "$ORIGINAL_SDK_PATH" "$INTERNAL_SDK_PATH"

# Update SDKSettings.plist in the Internal SDK
PLIST_PATH="$INTERNAL_SDK_PATH/SDKSettings.plist"

if [ -f "$PLIST_PATH" ]; then
    echo "Updating SDKSettings.plist..."
    
    # Get current DisplayName and add " Internal"
    CURRENT_DISPLAY_NAME=$(plutil -extract DisplayName raw "$PLIST_PATH" 2>/dev/null || echo "")
    if [ -n "$CURRENT_DISPLAY_NAME" ]; then
        NEW_DISPLAY_NAME="$CURRENT_DISPLAY_NAME Internal"
        plutil -replace DisplayName -string "$NEW_DISPLAY_NAME" "$PLIST_PATH"
        echo "  Updated DisplayName: $CURRENT_DISPLAY_NAME -> $NEW_DISPLAY_NAME"
    fi
    
    # Get current CanonicalName and add ".internal"
    CURRENT_CANONICAL_NAME=$(plutil -extract CanonicalName raw "$PLIST_PATH" 2>/dev/null || echo "")
    if [ -n "$CURRENT_CANONICAL_NAME" ]; then
        NEW_CANONICAL_NAME="$CURRENT_CANONICAL_NAME.internal"
        plutil -replace CanonicalName -string "$NEW_CANONICAL_NAME" "$PLIST_PATH"
        echo "  Updated CanonicalName: $CURRENT_CANONICAL_NAME -> $NEW_CANONICAL_NAME"
    fi
    
    # Get version number for soft links
    VERSION=$(plutil -extract Version raw "$PLIST_PATH" 2>/dev/null || echo "")
    
    # Create version-based soft links
    if [ -n "$VERSION" ]; then
        SDK_DIR="$XCODE_PATH/Platforms/$PLATFORM.platform/Developer/SDKs"
        cd "$SDK_DIR"
        
        if [ "$PLATFORM" = "MacOSX" ]; then
            # Extract major and minor version (e.g., 15.5 from 15.5.0)
            MAJOR_MINOR=$(echo "$VERSION" | cut -d. -f1-2)
            MAJOR=$(echo "$VERSION" | cut -d. -f1)
            
            ln -sf "$PLATFORM.Internal.sdk" "$PLATFORM$MAJOR_MINOR.Internal.sdk"
            ln -sf "$PLATFORM.Internal.sdk" "$PLATFORM$MAJOR.Internal.sdk"
            echo "  Created soft links: $PLATFORM$MAJOR_MINOR.Internal.sdk and $PLATFORM$MAJOR.Internal.sdk"
            
        else
            # Extract major and minor version
            MAJOR_MINOR=$(echo "$VERSION" | cut -d. -f1-2)
            
            ln -sf "$PLATFORM.Internal.sdk" "$PLATFORM$MAJOR_MINOR.Internal.sdk"
            echo "  Created soft link: $PLATFORM$MAJOR_MINOR.Internal.sdk"
        fi
    fi
else
    echo "Warning: SDKSettings.plist not found at: $PLIST_PATH"
fi

echo "Successfully created Internal SDK at: $INTERNAL_SDK_PATH"

# Install AG frameworks
echo "Installing AttributeGraph frameworks..."
"$REPO_ROOT/Scripts/install_ag.sh" "$INTERNAL_SDK_PATH" "$PLATFORM"

# TODO: Only support install AG for now as other frameworks are not ready yet