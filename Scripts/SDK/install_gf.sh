#!/bin/bash

set -e

# Function to get absolute path
filepath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

# Define repository root
REPO_ROOT=$(filepath "$(dirname "$0")/../..")

# Check arguments
if [ $# -lt 2 ]; then
    echo "Usage: $0 <sdk_root_path> <platform>"
    echo "  sdk_root_path: Path to Internal SDK"
    echo "  platform: MacOSX, iPhoneSimulator, iPhoneOS, or XRSimulator"
    exit 1
fi

SDK_ROOT="$1"
PLATFORM="$2"

# Calculate Gestures framework path
SDK_GF_FRAMEWORK_PATH="$SDK_ROOT/System/Library/PrivateFrameworks/Gestures.framework"
mkdir -p "$SDK_GF_FRAMEWORK_PATH"

echo "Installing Gestures framework to: $SDK_GF_FRAMEWORK_PATH"

case "$PLATFORM" in
    "MacOSX")
        echo "Setting up MacOSX Gestures framework..."

        # Create Versions structure for macOS framework
        mkdir -p "$SDK_GF_FRAMEWORK_PATH/Versions/A"
        cd "$SDK_GF_FRAMEWORK_PATH/Versions"
        ln -sfn A Current

        # Source paths
        REPO_SDK_GF_FRAMEWORK_PATH="$REPO_ROOT/GF/2025/Gestures.xcframework/macos-arm64e-arm64-x86_64/Gestures.framework"
        SYSTEM_GF_RESOURCES="/System/Library/PrivateFrameworks/Gestures.framework/Versions/A/Resources"

        # Copy Headers and Modules from xcframework
        if [ -d "$REPO_SDK_GF_FRAMEWORK_PATH/Headers" ]; then
            cp -R "$REPO_SDK_GF_FRAMEWORK_PATH/Headers" "$SDK_GF_FRAMEWORK_PATH/Versions/Current/"
            echo "  Copied Headers"
        fi

        if [ -d "$REPO_SDK_GF_FRAMEWORK_PATH/Modules" ]; then
            cp -R "$REPO_SDK_GF_FRAMEWORK_PATH/Modules" "$SDK_GF_FRAMEWORK_PATH/Versions/Current/"
            echo "  Copied Modules"
        fi

        # Copy Resources from system framework
        if [ -d "$SYSTEM_GF_RESOURCES" ]; then
            cp -R "$SYSTEM_GF_RESOURCES" "$SDK_GF_FRAMEWORK_PATH/Versions/Current/"
            echo "  Copied Resources"
        fi

        # Copy TBD file if it exists
        if [ -f "$SDK_GF_FRAMEWORK_PATH/Versions/Current/Gestures.tbd" ]; then
            # TBD already exists, keep it
            echo "  Using existing Gestures.tbd"
        elif [ -f "$REPO_SDK_GF_FRAMEWORK_PATH/Gestures.tbd" ]; then
            cp "$REPO_SDK_GF_FRAMEWORK_PATH/Gestures.tbd" "$SDK_GF_FRAMEWORK_PATH/Versions/Current/"
            echo "  Copied Gestures.tbd"
        fi

        # Create symbolic links
        cd "$SDK_GF_FRAMEWORK_PATH"
        ln -sf Versions/Current/Headers Headers
        ln -sf Versions/Current/Modules Modules
        ln -sf Versions/Current/Resources Resources
        ln -sf Versions/Current/Gestures.tbd Gestures.tbd
        echo "  Created symbolic links"
        ;;

    "iPhoneSimulator")
        echo "Setting up iPhoneSimulator Gestures framework..."

        # Source paths
        REPO_SDK_GF_FRAMEWORK_PATH="$REPO_ROOT/GF/2025/Gestures.xcframework/ios-arm64-x86_64-simulator/Gestures.framework"

        # Copy Headers and Modules from xcframework directly to framework root
        if [ -d "$REPO_SDK_GF_FRAMEWORK_PATH/Headers" ]; then
            cp -R "$REPO_SDK_GF_FRAMEWORK_PATH/Headers" "$SDK_GF_FRAMEWORK_PATH/"
            echo "  Copied Headers"
        fi

        if [ -d "$REPO_SDK_GF_FRAMEWORK_PATH/Modules" ]; then
            cp -R "$REPO_SDK_GF_FRAMEWORK_PATH/Modules" "$SDK_GF_FRAMEWORK_PATH/"
            echo "  Copied Modules"
        fi

        # Check for Simulator root via environment variable
        if [ -n "$SIMULATOR_RUNTIME_ROOT" ] && [ -d "$SIMULATOR_RUNTIME_ROOT" ]; then
            echo "  Using Simulator runtime root from environment: $SIMULATOR_RUNTIME_ROOT"
            SYSTEM_GF_FRAMEWORK_PATH="$SIMULATOR_RUNTIME_ROOT/System/Library/PrivateFrameworks/Gestures.framework"
            SYSTEM_GF_INFO="$SYSTEM_GF_FRAMEWORK_PATH/Info.plist"
            SYSTEM_GF_TBD="$SYSTEM_GF_FRAMEWORK_PATH/Gestures.tbd"

            # Copy Resources from system framework
            if [ -f "$SYSTEM_GF_INFO" ]; then
                cp "$SYSTEM_GF_INFO" "$SDK_GF_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from Simulator runtime"
            fi

            if [ -f "$SYSTEM_GF_TBD" ]; then
                cp "$SYSTEM_GF_TBD" "$SDK_GF_FRAMEWORK_PATH/"
                echo "  Copied Gestures.tbd from Simulator runtime"
            fi
        else
            echo "  SIMULATOR_RUNTIME_ROOT not set or directory doesn't exist, using fallback files from this repository"
            echo "  To use Simulator files, set SIMULATOR_RUNTIME_ROOT environment variable:"
            echo "  For example:"
            echo "  export SIMULATOR_RUNTIME_ROOT=\"/Library/Developer/CoreSimulator/Volumes/iOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.5.simruntime/Contents/Resources/RuntimeRoot\""

            # Use fallback files from repository
            if [ -f "$REPO_SDK_GF_FRAMEWORK_PATH/Info.plist" ]; then
                cp "$REPO_SDK_GF_FRAMEWORK_PATH/Info.plist" "$SDK_GF_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from repository"
            fi

            if [ -f "$REPO_SDK_GF_FRAMEWORK_PATH/Gestures.tbd" ]; then
                cp "$REPO_SDK_GF_FRAMEWORK_PATH/Gestures.tbd" "$SDK_GF_FRAMEWORK_PATH/"
                echo "  Copied Gestures.tbd from repository"
            fi
        fi
        ;;

    "iPhoneOS"|"XRSimulator")
        echo "Warning: Gestures framework is not available for $PLATFORM, skipping"
        ;;

    *)
        echo "Error: Unsupported platform: $PLATFORM"
        exit 1
        ;;
esac

echo "Successfully installed Gestures framework"
