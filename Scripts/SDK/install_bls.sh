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
    echo "  platform: iPhoneSimulator, iPhoneOS, or XRSimulator (BacklightServices not available for MacOSX)"
    exit 1
fi

SDK_ROOT="$1"
PLATFORM="$2"

# Calculate BLS framework path
SDK_BLS_FRAMEWORK_PATH="$SDK_ROOT/System/Library/PrivateFrameworks/BacklightServices.framework"
mkdir -p "$SDK_BLS_FRAMEWORK_PATH"

echo "Installing BacklightServices framework to: $SDK_BLS_FRAMEWORK_PATH"

case "$PLATFORM" in
    "MacOSX")
        echo "Error: BacklightServices framework is not available for MacOSX platform"
        echo "BacklightServices is only available for iOS and visionOS platforms"
        exit 1
        ;;

    "iPhoneSimulator")
        echo "Setting up iPhoneSimulator BacklightServices framework..."
        
        # Source paths
        REPO_SDK_BLS_FRAMEWORK_PATH="$REPO_ROOT/BLS/2024/BacklightServices.xcframework/ios-arm64-x86_64-simulator/BacklightServices.framework"

        # Copy Headers and Modules from xcframework directly to framework root
        if [ -d "$REPO_SDK_BLS_FRAMEWORK_PATH/Headers" ]; then
            cp -R "$REPO_SDK_BLS_FRAMEWORK_PATH/Headers" "$SDK_BLS_FRAMEWORK_PATH/"
            echo "  Copied Headers"
        fi
        
        if [ -d "$REPO_SDK_BLS_FRAMEWORK_PATH/Modules" ]; then
            cp -R "$REPO_SDK_BLS_FRAMEWORK_PATH/Modules" "$SDK_BLS_FRAMEWORK_PATH/"
            echo "  Copied Modules"
        fi

        # Check for Simulator root via environment variable
        if [ -n "$SIMULATOR_RUNTIME_ROOT" ] && [ -d "$SIMULATOR_RUNTIME_ROOT" ]; then
            echo "  Using Simulator runtime root from environment: $SIMULATOR_RUNTIME_ROOT"
            SYSTEM_BLS_FRAMEWORK_PATH="$SIMULATOR_RUNTIME_ROOT/System/Library/PrivateFrameworks/BacklightServices.framework"
            SYSTEM_BLS_INFO="$SYSTEM_BLS_FRAMEWORK_PATH/Info.plist"
            SYSTEM_BLS_TBD="$SYSTEM_BLS_FRAMEWORK_PATH/BacklightServices.tbd"
            
            # Copy Resources from system framework
            if [ -f "$SYSTEM_BLS_INFO" ]; then
                cp "$SYSTEM_BLS_INFO" "$SDK_BLS_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from Simulator runtime"
            fi
            
            if [ -f "$SYSTEM_BLS_TBD" ]; then
                cp "$SYSTEM_BLS_TBD" "$SDK_BLS_FRAMEWORK_PATH/"
                echo "  Copied BacklightServices.tbd from Simulator runtime"
            fi
        else
            echo "  SIMULATOR_RUNTIME_ROOT not set or directory doesn't exist, using fallback files from this repository"
            echo "  To use Simulator files, set SIMULATOR_RUNTIME_ROOT environment variable:"
            echo "  For example:"
            echo "  export SIMULATOR_RUNTIME_ROOT=\"/Library/Developer/CoreSimulator/Volumes/iOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.5.simruntime/Contents/Resources/RuntimeRoot\""

            # Use fallback files from repository
            if [ -f "$REPO_SDK_BLS_FRAMEWORK_PATH/Info.plist" ]; then
                cp "$REPO_SDK_BLS_FRAMEWORK_PATH/Info.plist" "$SDK_BLS_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from repository"
            fi
            
            if [ -f "$REPO_SDK_BLS_FRAMEWORK_PATH/BacklightServices.tbd" ]; then
                cp "$REPO_SDK_BLS_FRAMEWORK_PATH/BacklightServices.tbd" "$SDK_BLS_FRAMEWORK_PATH/"
                echo "  Copied BacklightServices.tbd from repository"
            fi
        fi
        ;;
        
    "iPhoneOS")
        echo "Setting up iPhoneOS BacklightServices framework..."
        
        # Source paths
        REPO_SDK_BLS_FRAMEWORK_PATH="$REPO_ROOT/BLS/2024/BacklightServices.xcframework/ios-arm64-arm64e/BacklightServices.framework"

        # Copy Headers and Modules from xcframework directly to framework root
        if [ -d "$REPO_SDK_BLS_FRAMEWORK_PATH/Headers" ]; then
            cp -R "$REPO_SDK_BLS_FRAMEWORK_PATH/Headers" "$SDK_BLS_FRAMEWORK_PATH/"
            echo "  Copied Headers"
        fi

        if [ -d "$REPO_SDK_BLS_FRAMEWORK_PATH/Modules" ]; then
            cp -R "$REPO_SDK_BLS_FRAMEWORK_PATH/Modules" "$SDK_BLS_FRAMEWORK_PATH/"
            echo "  Copied Modules"
        fi

        # Check for iOS IPSW root via environment variable
        if [ -n "$IOS_IPSW_ROOT" ] && [ -d "$IOS_IPSW_ROOT" ]; then
            echo "  Using iOS IPSW root from environment: $IOS_IPSW_ROOT"
            SYSTEM_BLS_FRAMEWORK_PATH="$IOS_IPSW_ROOT/System/Library/PrivateFrameworks/BacklightServices.framework"
            SYSTEM_BLS_INFO="$SYSTEM_BLS_FRAMEWORK_PATH/Info.plist"
            SYSTEM_BLS_TBD="$SYSTEM_BLS_FRAMEWORK_PATH/BacklightServices.tbd"
            
            # Copy Resources from system framework
            if [ -f "$SYSTEM_BLS_INFO" ]; then
                cp "$SYSTEM_BLS_INFO" "$SDK_BLS_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from iOS IPSW"
            fi
            
            if [ -f "$SYSTEM_BLS_TBD" ]; then
                cp "$SYSTEM_BLS_TBD" "$SDK_BLS_FRAMEWORK_PATH/"
                echo "  Copied BacklightServices.tbd from iOS IPSW"
            fi
        else
            echo "  IOS_IPSW_ROOT not set or directory doesn't exist, using fallback files from this repository"
            echo "  To use iOS IPSW files, set IOS_IPSW_ROOT environment variable:"
            echo "  For example:"
            echo "  export IOS_IPSW_ROOT=\"/path/to/extracted/ipsw/root\""
            
            # Use fallback files from repository
            if [ -f "$REPO_SDK_BLS_FRAMEWORK_PATH/Info.plist" ]; then
                cp "$REPO_SDK_BLS_FRAMEWORK_PATH/Info.plist" "$SDK_BLS_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from repository"
            fi
            
            if [ -f "$REPO_SDK_BLS_FRAMEWORK_PATH/BacklightServices.tbd" ]; then
                cp "$REPO_SDK_BLS_FRAMEWORK_PATH/BacklightServices.tbd" "$SDK_BLS_FRAMEWORK_PATH/"
                echo "  Copied BacklightServices.tbd from repository"
            fi
        fi
        ;;

    "XRSimulator")
        echo "Setting up XRSimulator BacklightServices framework..."

        # Source paths
        REPO_SDK_BLS_FRAMEWORK_PATH="$REPO_ROOT/BLS/2024/BacklightServices.xcframework/xros-arm64-x86_64-simulator/BacklightServices.framework"

        # Copy Headers and Modules from xcframework directly to framework root
        if [ -d "$REPO_SDK_BLS_FRAMEWORK_PATH/Headers" ]; then
            cp -R "$REPO_SDK_BLS_FRAMEWORK_PATH/Headers" "$SDK_BLS_FRAMEWORK_PATH/"
            echo "  Copied Headers"
        fi

        if [ -d "$REPO_SDK_BLS_FRAMEWORK_PATH/Modules" ]; then
            cp -R "$REPO_SDK_BLS_FRAMEWORK_PATH/Modules" "$SDK_BLS_FRAMEWORK_PATH/"
            echo "  Copied Modules"
        fi

        # Check for XR Simulator root via environment variable
        if [ -n "$XR_SIMULATOR_RUNTIME_ROOT" ] && [ -d "$XR_SIMULATOR_RUNTIME_ROOT" ]; then
            echo "  Using XR Simulator runtime root from environment: $XR_SIMULATOR_RUNTIME_ROOT"
            SYSTEM_BLS_FRAMEWORK_PATH="$XR_SIMULATOR_RUNTIME_ROOT/System/Library/PrivateFrameworks/BacklightServices.framework"
            SYSTEM_BLS_INFO="$SYSTEM_BLS_FRAMEWORK_PATH/Info.plist"
            SYSTEM_BLS_TBD="$SYSTEM_BLS_FRAMEWORK_PATH/BacklightServices.tbd"

            # Copy Resources from system framework
            if [ -f "$SYSTEM_BLS_INFO" ]; then
                cp "$SYSTEM_BLS_INFO" "$SDK_BLS_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from XR Simulator runtime"
            fi

            if [ -f "$SYSTEM_BLS_TBD" ]; then
                cp "$SYSTEM_BLS_TBD" "$SDK_BLS_FRAMEWORK_PATH/"
                echo "  Copied BacklightServices.tbd from XR Simulator runtime"
            fi
        else
            echo "  XR_SIMULATOR_RUNTIME_ROOT not set or directory doesn't exist, using fallback files from this repository"
            echo "  To use XR Simulator files, set XR_SIMULATOR_RUNTIME_ROOT environment variable:"
            echo "  For example:"
            echo "  export XR_SIMULATOR_RUNTIME_ROOT=\"/Library/Developer/CoreSimulator/Volumes/xrOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/xrOS 2.0.simruntime/Contents/Resources/RuntimeRoot\""

            # Use fallback files from repository
            if [ -f "$REPO_SDK_BLS_FRAMEWORK_PATH/Info.plist" ]; then
                cp "$REPO_SDK_BLS_FRAMEWORK_PATH/Info.plist" "$SDK_BLS_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from repository"
            fi

            if [ -f "$REPO_SDK_BLS_FRAMEWORK_PATH/BacklightServices.tbd" ]; then
                cp "$REPO_SDK_BLS_FRAMEWORK_PATH/BacklightServices.tbd" "$SDK_BLS_FRAMEWORK_PATH/"
                echo "  Copied BacklightServices.tbd from repository"
            fi
        fi
        ;;

    *)
        echo "Error: Unsupported platform: $PLATFORM"
        exit 1
        ;;
esac

echo "Successfully installed BacklightServices framework"