#!/bin/bash

set -e

# Function to get absolute path
filepath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

# Define repository root
REPO_ROOT=$(filepath "$(dirname "$0")/..")

# Check arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 <sdk_root_path> <platform>"
    echo "  sdk_root_path: Path to Internal SDK"
    echo "  platform: MacOSX or iPhoneSimulator"
    exit 1
fi

SDK_ROOT="$1"
PLATFORM="$2"

# Calculate AG framework path
SDK_AG_FRAMEWORK_PATH="$SDK_ROOT/System/Library/PrivateFrameworks/AttributeGraph.framework"

echo "Installing AttributeGraph framework to: $SDK_AG_FRAMEWORK_PATH"

case "$PLATFORM" in
    "MacOSX")
        echo "Setting up MacOSX AttributeGraph framework..."
        
        # Source paths
        REPO_SDK_AG_FRAMEWORK_PATH="$REPO_ROOT/AG/latest/AttributeGraph.xcframework/macos-arm64e-arm64-x86_64/AttributeGraph.framework"
        SYSTEM_AG_RESOURCES="/System/Library/PrivateFrameworks/AttributeGraph.framework/Resources"
        
        # Copy Headers and Modules from xcframework
        if [ -d "$REPO_SDK_AG_FRAMEWORK_PATH/Headers" ]; then
            cp -R "$REPO_SDK_AG_FRAMEWORK_PATH/Headers" "$SDK_AG_FRAMEWORK_PATH/Versions/Current/"
            echo "  Copied Headers"
        fi
        
        if [ -d "$REPO_SDK_AG_FRAMEWORK_PATH/Modules" ]; then
            cp -R "$REPO_SDK_AG_FRAMEWORK_PATH/Modules" "$SDK_AG_FRAMEWORK_PATH/Versions/Current/"
            echo "  Copied Modules"
        fi
        
        # Copy Resources from system framework
        if [ -d "$SYSTEM_AG_RESOURCES" ]; then
            cp -R "$SYSTEM_AG_RESOURCES" "$SDK_AG_FRAMEWORK_PATH/Versions/Current/"
            echo "  Copied Resources"
        fi
        
        # Copy TBD file if it exists
        if [ -f "$SDK_AG_FRAMEWORK_PATH/Versions/Current/AttributeGraph.tbd" ]; then
            # TBD already exists, keep it
            echo "  Using existing AttributeGraph.tbd"
        elif [ -f "$REPO_SDK_AG_FRAMEWORK_PATH/AttributeGraph.tbd" ]; then
            cp "$REPO_SDK_AG_FRAMEWORK_PATH/AttributeGraph.tbd" "$SDK_AG_FRAMEWORK_PATH/Versions/Current/"
            echo "  Copied AttributeGraph.tbd"
        fi
        
        # Create symbolic links        
        cd "$SDK_AG_FRAMEWORK_PATH"
        ln -sf Versions/Current/Headers Headers
        ln -sf Versions/Current/Modules Modules
        ln -sf Versions/Current/Resources Resources
        ln -sf Versions/Current/AttributeGraph.tbd AttributeGraph.tbd
        echo "  Created symbolic links"
        ;;
        
    "iPhoneSimulator")
        echo "iPhoneSimulator support not implemented yet"
        ;;
        
    *)
        echo "Error: Unsupported platform: $PLATFORM"
        exit 1
        ;;
esac

echo "Successfully installed AttributeGraph framework"
