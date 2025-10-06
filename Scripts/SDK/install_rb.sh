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

# Calculate RenderBox framework path
SDK_RB_FRAMEWORK_PATH="$SDK_ROOT/System/Library/PrivateFrameworks/RenderBox.framework"
mkdir -p "$SDK_RB_FRAMEWORK_PATH"

echo "Installing RenderBox framework to: $SDK_RB_FRAMEWORK_PATH"

case "$PLATFORM" in
    "MacOSX")
        echo "Setting up MacOSX RenderBox framework..."

        # Create Versions structure for macOS framework
        mkdir -p "$SDK_RB_FRAMEWORK_PATH/Versions/A"
        cd "$SDK_RB_FRAMEWORK_PATH/Versions"
        ln -sfn A Current

        # Source paths
        REPO_SDK_RB_FRAMEWORK_PATH="$REPO_ROOT/RB/2024/RenderBox.xcframework/macos-arm64e-arm64-x86_64/RenderBox.framework"
        SYSTEM_RB_RESOURCES="/System/Library/PrivateFrameworks/RenderBox.framework/Versions/A/Resources"

        # Copy Headers and Modules from xcframework
        if [ -d "$REPO_SDK_RB_FRAMEWORK_PATH/Headers" ]; then
            cp -R "$REPO_SDK_RB_FRAMEWORK_PATH/Headers" "$SDK_RB_FRAMEWORK_PATH/Versions/Current/"
            echo "  Copied Headers"
        fi
        
        if [ -d "$REPO_SDK_RB_FRAMEWORK_PATH/Modules" ]; then
            cp -R "$REPO_SDK_RB_FRAMEWORK_PATH/Modules" "$SDK_RB_FRAMEWORK_PATH/Versions/Current/"
            echo "  Copied Modules"
        fi
        
        # Copy Resources from system framework
        if [ -d "$SYSTEM_RB_RESOURCES" ]; then
            cp -R "$SYSTEM_RB_RESOURCES" "$SDK_RB_FRAMEWORK_PATH/Versions/Current/"
            echo "  Copied Resources"
        fi
        
        # Copy TBD file if it exists
        if [ -f "$SDK_RB_FRAMEWORK_PATH/Versions/Current/RenderBox.tbd" ]; then
            # TBD already exists, keep it
            echo "  Using existing RenderBox.tbd"
        elif [ -f "$REPO_SDK_RB_FRAMEWORK_PATH/RenderBox.tbd" ]; then
            cp "$REPO_SDK_RB_FRAMEWORK_PATH/RenderBox.tbd" "$SDK_RB_FRAMEWORK_PATH/Versions/Current/"
            echo "  Copied RenderBox.tbd"
        fi
        
        # Create symbolic links        
        cd "$SDK_RB_FRAMEWORK_PATH"
        ln -sf Versions/Current/Headers Headers
        ln -sf Versions/Current/Modules Modules
        ln -sf Versions/Current/Resources Resources
        ln -sf Versions/Current/RenderBox.tbd RenderBox.tbd
        echo "  Created symbolic links"
        ;;
        
    "iPhoneSimulator")
        echo "Setting up iPhoneSimulator RenderBox framework..."
        
        # Source paths
        REPO_SDK_RB_FRAMEWORK_PATH="$REPO_ROOT/RB/2024/RenderBox.xcframework/ios-arm64-x86_64-simulator/RenderBox.framework"

        # Copy Headers and Modules from xcframework directly to framework root
        if [ -d "$REPO_SDK_RB_FRAMEWORK_PATH/Headers" ]; then
            cp -R "$REPO_SDK_RB_FRAMEWORK_PATH/Headers" "$SDK_RB_FRAMEWORK_PATH/"
            echo "  Copied Headers"
        fi
        
        if [ -d "$REPO_SDK_RB_FRAMEWORK_PATH/Modules" ]; then
            cp -R "$REPO_SDK_RB_FRAMEWORK_PATH/Modules" "$SDK_RB_FRAMEWORK_PATH/"
            echo "  Copied Modules"
        fi

        # Check for Simulator root via environment variable
        if [ -n "$SIMULATOR_RUNTIME_ROOT" ] && [ -d "$SIMULATOR_RUNTIME_ROOT" ]; then
            echo "  Using Simulator runtime root from environment: $SIMULATOR_RUNTIME_ROOT"
            SYSTEM_RB_FRAMEWORK_PATH="$SIMULATOR_RUNTIME_ROOT/System/Library/PrivateFrameworks/RenderBox.framework"
            SYSTEM_RB_INFO="$SYSTEM_RB_FRAMEWORK_PATH/Info.plist"
            SYSTEM_RB_TBD="$SYSTEM_RB_FRAMEWORK_PATH/RenderBox.tbd"
            
            # Copy Resources from system framework
            if [ -f "$SYSTEM_RB_INFO" ]; then
                cp "$SYSTEM_RB_INFO" "$SDK_RB_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from Simulator runtime"
            fi
            
            if [ -f "$SYSTEM_RB_TBD" ]; then
                cp "$SYSTEM_RB_TBD" "$SDK_RB_FRAMEWORK_PATH/"
                echo "  Copied RenderBox.tbd from Simulator runtime"
            fi
        else
            echo "  SIMULATOR_RUNTIME_ROOT not set or directory doesn't exist, using fallback files from this repository"
            echo "  To use Simulator files, set SIMULATOR_RUNTIME_ROOT environment variable:"
            echo "  For example:"
            echo "  export SIMULATOR_RUNTIME_ROOT=\"/Library/Developer/CoreSimulator/Volumes/iOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.5.simruntime/Contents/Resources/RuntimeRoot\""

            # Use fallback files from repository
            if [ -f "$REPO_SDK_RB_FRAMEWORK_PATH/Info.plist" ]; then
                cp "$REPO_SDK_RB_FRAMEWORK_PATH/Info.plist" "$SDK_RB_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from repository"
            fi
            
            if [ -f "$REPO_SDK_RB_FRAMEWORK_PATH/RenderBox.tbd" ]; then
                cp "$REPO_SDK_RB_FRAMEWORK_PATH/RenderBox.tbd" "$SDK_RB_FRAMEWORK_PATH/"
                echo "  Copied RenderBox.tbd from repository"
            fi
        fi
        ;;
        
    "iPhoneOS")
        echo "Setting up iPhoneOS RenderBox framework..."
        
        # Source paths
        REPO_SDK_RB_FRAMEWORK_PATH="$REPO_ROOT/RB/2024/RenderBox.xcframework/ios-arm64-arm64e/RenderBox.framework"

        # Copy Headers and Modules from xcframework directly to framework root
        if [ -d "$REPO_SDK_RB_FRAMEWORK_PATH/Headers" ]; then
            cp -R "$REPO_SDK_RB_FRAMEWORK_PATH/Headers" "$SDK_RB_FRAMEWORK_PATH/"
            echo "  Copied Headers"
        fi

        if [ -d "$REPO_SDK_RB_FRAMEWORK_PATH/Modules" ]; then
            cp -R "$REPO_SDK_RB_FRAMEWORK_PATH/Modules" "$SDK_RB_FRAMEWORK_PATH/"
            echo "  Copied Modules"
        fi

        # Check for iOS IPSW root via environment variable
        if [ -n "$IOS_IPSW_ROOT" ] && [ -d "$IOS_IPSW_ROOT" ]; then
            echo "  Using iOS IPSW root from environment: $IOS_IPSW_ROOT"
            SYSTEM_RB_FRAMEWORK_PATH="$IOS_IPSW_ROOT/System/Library/PrivateFrameworks/RenderBox.framework"
            SYSTEM_RB_INFO="$SYSTEM_RB_FRAMEWORK_PATH/Info.plist"
            SYSTEM_RB_TBD="$SYSTEM_RB_FRAMEWORK_PATH/RenderBox.tbd"
            
            # Copy Resources from system framework
            if [ -f "$SYSTEM_RB_INFO" ]; then
                cp "$SYSTEM_RB_INFO" "$SDK_RB_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from iOS IPSW"
            fi
            
            if [ -f "$SYSTEM_RB_TBD" ]; then
                cp "$SYSTEM_RB_TBD" "$SDK_RB_FRAMEWORK_PATH/"
                echo "  Copied RenderBox.tbd from iOS IPSW"
            fi
        else
            echo "  IOS_IPSW_ROOT not set or directory doesn't exist, using fallback files from this repository"
            echo "  To use iOS IPSW files, set IOS_IPSW_ROOT environment variable:"
            echo "  For example:"
            echo "  export IOS_IPSW_ROOT=\"/path/to/extracted/ipsw/root\""
            
            # Use fallback files from repository
            if [ -f "$REPO_SDK_RB_FRAMEWORK_PATH/Info.plist" ]; then
                cp "$REPO_SDK_RB_FRAMEWORK_PATH/Info.plist" "$SDK_RB_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from repository"
            fi
            
            if [ -f "$REPO_SDK_RB_FRAMEWORK_PATH/RenderBox.tbd" ]; then
                cp "$REPO_SDK_RB_FRAMEWORK_PATH/RenderBox.tbd" "$SDK_RB_FRAMEWORK_PATH/"
                echo "  Copied RenderBox.tbd from repository"
            fi
        fi
        ;;

    "XRSimulator")
        echo "Setting up XRSimulator RenderBox framework..."

        # Source paths
        REPO_SDK_RB_FRAMEWORK_PATH="$REPO_ROOT/RB/2024/RenderBox.xcframework/xros-arm64-x86_64-simulator/RenderBox.framework"

        # Copy Headers and Modules from xcframework directly to framework root
        if [ -d "$REPO_SDK_RB_FRAMEWORK_PATH/Headers" ]; then
            cp -R "$REPO_SDK_RB_FRAMEWORK_PATH/Headers" "$SDK_RB_FRAMEWORK_PATH/"
            echo "  Copied Headers"
        fi

        if [ -d "$REPO_SDK_RB_FRAMEWORK_PATH/Modules" ]; then
            cp -R "$REPO_SDK_RB_FRAMEWORK_PATH/Modules" "$SDK_RB_FRAMEWORK_PATH/"
            echo "  Copied Modules"
        fi

        # Check for XR Simulator root via environment variable
        if [ -n "$XR_SIMULATOR_RUNTIME_ROOT" ] && [ -d "$XR_SIMULATOR_RUNTIME_ROOT" ]; then
            echo "  Using XR Simulator runtime root from environment: $XR_SIMULATOR_RUNTIME_ROOT"
            SYSTEM_RB_FRAMEWORK_PATH="$XR_SIMULATOR_RUNTIME_ROOT/System/Library/PrivateFrameworks/RenderBox.framework"
            SYSTEM_RB_INFO="$SYSTEM_RB_FRAMEWORK_PATH/Info.plist"
            SYSTEM_RB_TBD="$SYSTEM_RB_FRAMEWORK_PATH/RenderBox.tbd"

            # Copy Resources from system framework
            if [ -f "$SYSTEM_RB_INFO" ]; then
                cp "$SYSTEM_RB_INFO" "$SDK_RB_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from XR Simulator runtime"
            fi

            if [ -f "$SYSTEM_RB_TBD" ]; then
                cp "$SYSTEM_RB_TBD" "$SDK_RB_FRAMEWORK_PATH/"
                echo "  Copied RenderBox.tbd from XR Simulator runtime"
            fi
        else
            echo "  XR_SIMULATOR_RUNTIME_ROOT not set or directory doesn't exist, using fallback files from this repository"
            echo "  To use XR Simulator files, set XR_SIMULATOR_RUNTIME_ROOT environment variable:"
            echo "  For example:"
            echo "  export XR_SIMULATOR_RUNTIME_ROOT=\"/Library/Developer/CoreSimulator/Volumes/xrOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/xrOS 2.0.simruntime/Contents/Resources/RuntimeRoot\""

            # Use fallback files from repository
            if [ -f "$REPO_SDK_RB_FRAMEWORK_PATH/Info.plist" ]; then
                cp "$REPO_SDK_RB_FRAMEWORK_PATH/Info.plist" "$SDK_RB_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from repository"
            fi

            if [ -f "$REPO_SDK_RB_FRAMEWORK_PATH/RenderBox.tbd" ]; then
                cp "$REPO_SDK_RB_FRAMEWORK_PATH/RenderBox.tbd" "$SDK_RB_FRAMEWORK_PATH/"
                echo "  Copied RenderBox.tbd from repository"
            fi
        fi
        ;;

    *)
        echo "Error: Unsupported platform: $PLATFORM"
        exit 1
        ;;
esac

echo "Successfully installed RenderBox framework"