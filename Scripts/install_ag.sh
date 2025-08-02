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
    echo "  platform: MacOSX, iPhoneSimulator or iPhoneOS"
    exit 1
fi

SDK_ROOT="$1"
PLATFORM="$2"

# Calculate AG framework path
SDK_AG_FRAMEWORK_PATH="$SDK_ROOT/System/Library/PrivateFrameworks/AttributeGraph.framework"
mkdir -p "$SDK_AG_FRAMEWORK_PATH"

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
        echo "Setting up iPhoneSimulator AttributeGraph framework..."
        
        # Source paths
        REPO_SDK_AG_FRAMEWORK_PATH="$REPO_ROOT/AG/latest/AttributeGraph.xcframework/ios-arm64-x86_64-simulator/AttributeGraph.framework"

        # Copy Headers and Modules from xcframework directly to framework root
        if [ -d "$REPO_SDK_AG_FRAMEWORK_PATH/Headers" ]; then
            cp -R "$REPO_SDK_AG_FRAMEWORK_PATH/Headers" "$SDK_AG_FRAMEWORK_PATH/"
            echo "  Copied Headers"
        fi
        
        if [ -d "$REPO_SDK_AG_FRAMEWORK_PATH/Modules" ]; then
            cp -R "$REPO_SDK_AG_FRAMEWORK_PATH/Modules" "$SDK_AG_FRAMEWORK_PATH/"
            echo "  Copied Modules"
        fi

        # Check for Simulator root via environment variable
        if [ -n "$SIMULATOR_RUNTIME_ROOT" ] && [ -d "$SIMULATOR_RUNTIME_ROOT" ]; then
            echo "  Using Simulator runtime root from environment: $SIMULATOR_RUNTIME_ROOT"
            SYSTEM_AG_FRAMEWORK_PATH="$SIMULATOR_RUNTIME_ROOT/System/Library/PrivateFrameworks/AttributeGraph.framework"
            SYSTEM_AG_INFO="$SYSTEM_AG_FRAMEWORK_PATH/Info.plist"
            SYSTEM_AG_TBD="$SYSTEM_AG_FRAMEWORK_PATH/AttributeGraph.tbd"
            
            # Copy Resources from system framework
            if [ -f "$SYSTEM_AG_INFO" ]; then
                cp "$SYSTEM_AG_INFO" "$SDK_AG_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from Simulator runtime"
            fi
            
            if [ -f "$SYSTEM_AG_TBD" ]; then
                cp "$SYSTEM_AG_TBD" "$SDK_AG_FRAMEWORK_PATH/"
                echo "  Copied AttributeGraph.tbd from Simulator runtime"
            fi
        else
            echo "  SIMULATOR_RUNTIME_ROOT not set or directory doesn't exist, using fallback files from this repository"
            echo "  To use Simulator files, set SIMULATOR_RUNTIME_ROOT environment variable:"
            echo "  For example:"
            echo "  export SIMULATOR_RUNTIME_ROOT=\"/Library/Developer/CoreSimulator/Volumes/iOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.5.simruntime/Contents/Resources/RuntimeRoot\""

            # Use fallback files from repository
            if [ -f "$REPO_SDK_AG_FRAMEWORK_PATH/Info.plist" ]; then
                cp "$REPO_SDK_AG_FRAMEWORK_PATH/Info.plist" "$SDK_AG_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from repository"
            fi
            
            if [ -f "$REPO_SDK_AG_FRAMEWORK_PATH/AttributeGraph.tbd" ]; then
                cp "$REPO_SDK_AG_FRAMEWORK_PATH/AttributeGraph.tbd" "$SDK_AG_FRAMEWORK_PATH/"
                echo "  Copied AttributeGraph.tbd from repository"
            fi
        fi
        ;;
        
    "iPhoneOS")
        echo "Setting up iPhoneOS AttributeGraph framework..."
        
        # Source paths
        REPO_SDK_AG_FRAMEWORK_PATH="$REPO_ROOT/AG/latest/AttributeGraph.xcframework/ios-arm64-arm64e/AttributeGraph.framework"

        # Copy Headers and Modules from xcframework directly to framework root
        if [ -d "$REPO_SDK_AG_FRAMEWORK_PATH/Headers" ]; then
            cp -R "$REPO_SDK_AG_FRAMEWORK_PATH/Headers" "$SDK_AG_FRAMEWORK_PATH/"
            echo "  Copied Headers"
        fi

        if [ -d "$REPO_SDK_AG_FRAMEWORK_PATH/Modules" ]; then
            cp -R "$REPO_SDK_AG_FRAMEWORK_PATH/Modules" "$SDK_AG_FRAMEWORK_PATH/"
            echo "  Copied Modules"
        fi

        # Check for iOS IPSW root via environment variable
        if [ -n "$IOS_IPSW_ROOT" ] && [ -d "$IOS_IPSW_ROOT" ]; then
            echo "  Using iOS IPSW root from environment: $IOS_IPSW_ROOT"
            SYSTEM_AG_FRAMEWORK_PATH="$IOS_IPSW_ROOT/System/Library/PrivateFrameworks/AttributeGraph.framework"
            SYSTEM_AG_INFO="$SYSTEM_AG_FRAMEWORK_PATH/Info.plist"
            SYSTEM_AG_TBD="$SYSTEM_AG_FRAMEWORK_PATH/AttributeGraph.tbd"
            
            # Copy Resources from system framework
            if [ -f "$SYSTEM_AG_INFO" ]; then
                cp "$SYSTEM_AG_INFO" "$SDK_AG_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from iOS IPSW"
            fi
            
            if [ -f "$SYSTEM_AG_TBD" ]; then
                cp "$SYSTEM_AG_TBD" "$SDK_AG_FRAMEWORK_PATH/"
                echo "  Copied AttributeGraph.tbd from iOS IPSW"
            fi
        else
            echo "  IOS_IPSW_ROOT not set or directory doesn't exist, using fallback files from this repository"
            echo "  To use iOS IPSW files, set IOS_IPSW_ROOT environment variable:"
            echo "  For example:"
            echo "  export IOS_IPSW_ROOT=\"/path/to/extracted/ipsw/root\""
            
            # Use fallback files from repository
            if [ -f "$REPO_SDK_AG_FRAMEWORK_PATH/Info.plist" ]; then
                cp "$REPO_SDK_AG_FRAMEWORK_PATH/Info.plist" "$SDK_AG_FRAMEWORK_PATH/"
                echo "  Copied Info.plist from repository"
            fi
            
            if [ -f "$REPO_SDK_AG_FRAMEWORK_PATH/AttributeGraph.tbd" ]; then
                cp "$REPO_SDK_AG_FRAMEWORK_PATH/AttributeGraph.tbd" "$SDK_AG_FRAMEWORK_PATH/"
                echo "  Copied AttributeGraph.tbd from repository"
            fi
        fi
        ;;
        
    *)
        echo "Error: Unsupported platform: $PLATFORM"
        exit 1
        ;;
esac

echo "Successfully installed AttributeGraph framework"
