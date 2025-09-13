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
    echo "Usage: $0 <platform> [xcode_path] [-f] [-d]"
    echo "  platform: MacOSX, iPhoneSimulator, iPhoneOS, or XRSimulator"
    echo "  xcode_path: Path to Xcode developer directory (optional, defaults to xcode-select -p)"
    echo "  -f: Force installation (backup existing Internal SDK)"
    echo "  -d: Set Internal SDK as default (redirect versioned SDK symlink to Internal SDK)"
    echo ""
    echo "Example:"
    echo "  $0 MacOSX"
    echo "  $0 iPhoneSimulator /Applications/Xcode-16.4.0.app/Contents/Developer -f"
    echo "  $0 XRSimulator -d"
    echo "  $0 XRSimulator -f -d"
    exit 1
}

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    usage
fi

# Parse arguments
PLATFORM="$1"
FORCE_INSTALL=false
SET_DEFAULT=false
XCODE_PATH=""

# Parse remaining arguments
shift
while [ $# -gt 0 ]; do
    case "$1" in
        -f)
            FORCE_INSTALL=true
            ;;
        -d)
            SET_DEFAULT=true
            ;;
        -*)
            echo "Error: Unknown option: $1"
            usage
            ;;
        *)
            if [ -z "$XCODE_PATH" ]; then
                XCODE_PATH="$1"
            else
                echo "Error: Unexpected argument: $1"
                usage
            fi
            ;;
    esac
    shift
done

# Set default Xcode path if not provided
if [ -z "$XCODE_PATH" ]; then
    XCODE_PATH="$(xcode-select -p)"
fi

# Validate platform
if [ "$PLATFORM" != "MacOSX" ] && [ "$PLATFORM" != "iPhoneSimulator" ] && [ "$PLATFORM" != "iPhoneOS" ] && [ "$PLATFORM" != "XRSimulator" ]; then
    echo "Error: Only MacOSX, iPhoneSimulator, iPhoneOS, and XRSimulator platforms are supported"
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
    # Update SDKSettings.plist if it exists
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
    else
        echo "Warning: SDKSettings.plist not found at: $PLIST_PATH"
    fi

    
    # Update SDKSettings.json if it exists
    JSON_PATH="$INTERNAL_SDK_PATH/SDKSettings.json"
    if [ -f "$JSON_PATH" ]; then
        echo "Updating SDKSettings.json..."
        
        # Get current DisplayName and add " Internal"
        if [ -n "$CURRENT_DISPLAY_NAME" ]; then
            NEW_DISPLAY_NAME="$CURRENT_DISPLAY_NAME Internal"
            plutil -replace DisplayName -string "$NEW_DISPLAY_NAME" "$JSON_PATH"
            echo "  Updated DisplayName in JSON: $CURRENT_DISPLAY_NAME -> $NEW_DISPLAY_NAME"
        fi
        
        # Get current CanonicalName and add ".internal"
        if [ -n "$CURRENT_CANONICAL_NAME" ]; then
            NEW_CANONICAL_NAME="$CURRENT_CANONICAL_NAME.internal"
            plutil -replace CanonicalName -string "$NEW_CANONICAL_NAME" "$JSON_PATH"
            echo "  Updated CanonicalName in JSON: $CURRENT_CANONICAL_NAME -> $NEW_CANONICAL_NAME"
        fi
    else
        echo "Warning: SDKSettings.json not found at: $JSON_PATH"
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

            # Handle -d flag: redirect versioned SDK symlink to Internal SDK
            if [ "$SET_DEFAULT" = true ]; then
                echo ""
                echo "Setting Internal SDK as default..."

                # Backup original symlinks if they exist
                if [ -L "$PLATFORM$MAJOR_MINOR.sdk" ]; then
                    ORIGINAL_TARGET=$(readlink "$PLATFORM$MAJOR_MINOR.sdk")
                    echo "  Backing up $PLATFORM$MAJOR_MINOR.sdk -> $ORIGINAL_TARGET"
                    echo "$ORIGINAL_TARGET" > "$PLATFORM$MAJOR_MINOR.sdk.original"
                    rm -f "$PLATFORM$MAJOR_MINOR.sdk"
                    ln -sf "$PLATFORM.Internal.sdk" "$PLATFORM$MAJOR_MINOR.sdk"
                    echo "  Redirected $PLATFORM$MAJOR_MINOR.sdk -> $PLATFORM.Internal.sdk"
                fi

                if [ -L "$PLATFORM$MAJOR.sdk" ]; then
                    ORIGINAL_TARGET=$(readlink "$PLATFORM$MAJOR.sdk")
                    echo "  Backing up $PLATFORM$MAJOR.sdk -> $ORIGINAL_TARGET"
                    echo "$ORIGINAL_TARGET" > "$PLATFORM$MAJOR.sdk.original"
                    rm -f "$PLATFORM$MAJOR.sdk"
                    ln -sf "$PLATFORM.Internal.sdk" "$PLATFORM$MAJOR.sdk"
                    echo "  Redirected $PLATFORM$MAJOR.sdk -> $PLATFORM.Internal.sdk"
                fi
            fi

        else
            # Extract major and minor version
            MAJOR_MINOR=$(echo "$VERSION" | cut -d. -f1-2)

            ln -sf "$PLATFORM.Internal.sdk" "$PLATFORM$MAJOR_MINOR.Internal.sdk"
            echo "  Created soft link: $PLATFORM$MAJOR_MINOR.Internal.sdk"

            # Handle -d flag: redirect versioned SDK symlink to Internal SDK
            if [ "$SET_DEFAULT" = true ]; then
                echo ""
                echo "Setting Internal SDK as default..."

                # Backup original symlink if it exists
                if [ -L "$PLATFORM$MAJOR_MINOR.sdk" ]; then
                    ORIGINAL_TARGET=$(readlink "$PLATFORM$MAJOR_MINOR.sdk")
                    echo "  Backing up $PLATFORM$MAJOR_MINOR.sdk -> $ORIGINAL_TARGET"
                    echo "$ORIGINAL_TARGET" > "$PLATFORM$MAJOR_MINOR.sdk.original"
                    rm -f "$PLATFORM$MAJOR_MINOR.sdk"
                    ln -sf "$PLATFORM.Internal.sdk" "$PLATFORM$MAJOR_MINOR.sdk"
                    echo "  Redirected $PLATFORM$MAJOR_MINOR.sdk -> $PLATFORM.Internal.sdk"
                fi
            fi
        fi
    fi
else
    echo "Warning: SDKSettings.plist not found at: $PLIST_PATH"
fi

echo "Successfully created Internal SDK at: $INTERNAL_SDK_PATH"

# Install AG frameworks
echo "Installing AttributeGraph frameworks..."
"$REPO_ROOT/Scripts/install_ag.sh" "$INTERNAL_SDK_PATH" "$PLATFORM"

# Enable UIScreen support for XRSimulator
if [ "$PLATFORM" = "XRSimulator" ]; then
    echo "Enabling UIScreen support for visionOS SDK..."
    "$REPO_ROOT/Scripts/XR/enable_uiscreen_support.sh" "$INTERNAL_SDK_PATH"
fi

# Final message about default SDK
if [ "$SET_DEFAULT" = true ]; then
    echo ""
    echo "========================================="
    echo "Internal SDK is now set as the default SDK."
    echo "The versioned SDK symlinks now point to the Internal SDK."
    echo "To restore original configuration, use the .original files in:"
    echo "  $XCODE_PATH/Platforms/$PLATFORM.platform/Developer/SDKs/"
    echo "========================================="
fi

# TODO: Only support install AG for now as other frameworks are not ready yet