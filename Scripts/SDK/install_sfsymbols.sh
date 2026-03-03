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
    echo "  platform: MacOSX, iPhoneSimulator, or iPhoneOS"
    exit 1
fi

SDK_ROOT_PATH="$1"
PLATFORM_NAME="$2"

# Calculate SFSymbols framework path
SDK_FRAMEWORK_PATH="$SDK_ROOT_PATH/System/Library/PrivateFrameworks/SFSymbols.framework"
mkdir -p "$SDK_FRAMEWORK_PATH"

echo "Installing SFSymbols framework to: $SDK_FRAMEWORK_PATH"

case "$PLATFORM_NAME" in
    "MacOSX")
        echo "Setting up MacOSX SFSymbols framework..."

        REPOSITORY_FRAMEWORK_PATH="$REPO_ROOT/SFSymbols/2024/SFSymbols.xcframework/macos-arm64e-arm64-x86_64/SFSymbols.framework"

        if [ -d "$REPOSITORY_FRAMEWORK_PATH/Headers" ]; then
            cp -R "$REPOSITORY_FRAMEWORK_PATH/Headers" "$SDK_FRAMEWORK_PATH/"
            echo "  Copied Headers"
        fi

        if [ -d "$REPOSITORY_FRAMEWORK_PATH/Modules" ]; then
            cp -R "$REPOSITORY_FRAMEWORK_PATH/Modules" "$SDK_FRAMEWORK_PATH/"
            echo "  Copied Modules"
        fi

        if [ -f "$REPOSITORY_FRAMEWORK_PATH/Info.plist" ]; then
            cp "$REPOSITORY_FRAMEWORK_PATH/Info.plist" "$SDK_FRAMEWORK_PATH/"
            echo "  Copied Info.plist"
        fi

        if [ -f "$REPOSITORY_FRAMEWORK_PATH/SFSymbols.tbd" ]; then
            cp "$REPOSITORY_FRAMEWORK_PATH/SFSymbols.tbd" "$SDK_FRAMEWORK_PATH/"
            echo "  Copied SFSymbols.tbd"
        fi
        ;;

    "iPhoneSimulator")
        echo "Setting up iPhoneSimulator SFSymbols framework..."

        REPOSITORY_FRAMEWORK_PATH="$REPO_ROOT/SFSymbols/2024/SFSymbols.xcframework/ios-arm64-simulator/SFSymbols.framework"

        if [ -d "$REPOSITORY_FRAMEWORK_PATH/Headers" ]; then
            cp -R "$REPOSITORY_FRAMEWORK_PATH/Headers" "$SDK_FRAMEWORK_PATH/"
            echo "  Copied Headers"
        fi

        if [ -d "$REPOSITORY_FRAMEWORK_PATH/Modules" ]; then
            cp -R "$REPOSITORY_FRAMEWORK_PATH/Modules" "$SDK_FRAMEWORK_PATH/"
            echo "  Copied Modules"
        fi

        if [ -f "$REPOSITORY_FRAMEWORK_PATH/Info.plist" ]; then
            cp "$REPOSITORY_FRAMEWORK_PATH/Info.plist" "$SDK_FRAMEWORK_PATH/"
            echo "  Copied Info.plist from repository"
        fi

        if [ -f "$REPOSITORY_FRAMEWORK_PATH/SFSymbols.tbd" ]; then
            cp "$REPOSITORY_FRAMEWORK_PATH/SFSymbols.tbd" "$SDK_FRAMEWORK_PATH/"
            echo "  Copied SFSymbols.tbd from repository"
        fi
        ;;

    "iPhoneOS")
        echo "Setting up iPhoneOS SFSymbols framework..."

        REPOSITORY_FRAMEWORK_PATH="$REPO_ROOT/SFSymbols/2024/SFSymbols.xcframework/ios-arm64-arm64e/SFSymbols.framework"

        if [ -d "$REPOSITORY_FRAMEWORK_PATH/Headers" ]; then
            cp -R "$REPOSITORY_FRAMEWORK_PATH/Headers" "$SDK_FRAMEWORK_PATH/"
            echo "  Copied Headers"
        fi

        if [ -d "$REPOSITORY_FRAMEWORK_PATH/Modules" ]; then
            cp -R "$REPOSITORY_FRAMEWORK_PATH/Modules" "$SDK_FRAMEWORK_PATH/"
            echo "  Copied Modules"
        fi

        if [ -f "$REPOSITORY_FRAMEWORK_PATH/Info.plist" ]; then
            cp "$REPOSITORY_FRAMEWORK_PATH/Info.plist" "$SDK_FRAMEWORK_PATH/"
            echo "  Copied Info.plist from repository"
        fi

        if [ -f "$REPOSITORY_FRAMEWORK_PATH/SFSymbols.tbd" ]; then
            cp "$REPOSITORY_FRAMEWORK_PATH/SFSymbols.tbd" "$SDK_FRAMEWORK_PATH/"
            echo "  Copied SFSymbols.tbd from repository"
        fi
        ;;

    "XRSimulator")
        echo "Skipping SFSymbols framework (not currently available for XRSimulator)"
        exit 0
        ;;

    *)
        echo "Error: Unsupported platform: $PLATFORM_NAME"
        exit 1
        ;;
esac

echo "Successfully installed SFSymbols framework"
