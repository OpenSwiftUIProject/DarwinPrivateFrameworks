#!/bin/bash

# Script to generate TBD files for frameworks from any platform runtime
# Usage: ./generate_tbd.sh <platform> <runtime_base> <framework_name> [<framework_name> ...]
# Example: ./generate_tbd.sh xros "/Library/Developer/CoreSimulator/Volumes/xrOS_22O473/Library/Developer/CoreSimulator/Profiles/Runtimes/xrOS 2.5.simruntime" AttributeGraph RenderBox CoreUI
# Example: ./generate_tbd.sh ios "/Library/Developer/CoreSimulator/Volumes/iOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.5.simruntime" AttributeGraph RenderBox CoreUI

set -e

# Check if at least 3 arguments are provided
if [ $# -lt 3 ]; then
    echo "Usage: $0 <platform> <runtime_base> <framework_name> [<framework_name> ...]"
    echo "Example: $0 xros \"/Library/Developer/CoreSimulator/Volumes/xrOS_22O473/Library/Developer/CoreSimulator/Profiles/Runtimes/xrOS 2.5.simruntime\" AttributeGraph RenderBox CoreUI"
    echo "Example: $0 ios \"/Library/Developer/CoreSimulator/Volumes/iOS_22F77/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS 18.5.simruntime\" AttributeGraph"
    echo ""
    echo "Supported platforms: ios, xros, macos, tvos, watchos"
    exit 1
fi

PLATFORM="$1"
RUNTIME_BASE="$2"
shift 2  # Remove first two arguments, leaving only framework names

# Validate runtime base exists
if [ ! -d "$RUNTIME_BASE" ]; then
    echo "Error: Runtime base directory does not exist: $RUNTIME_BASE"
    exit 1
fi

RUNTIME_ROOT="${RUNTIME_BASE}/Contents/Resources/RuntimeRoot"
PRIVATE_FRAMEWORKS="${RUNTIME_ROOT}/System/Library/PrivateFrameworks"

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# Function to get platform-specific directory name
get_platform_dir() {
    local platform="$1"
    case "$platform" in
        ios)
            echo "ios-arm64-x86_64-simulator"
            ;;
        xros)
            echo "xros-arm64-x86_64-simulator"
            ;;
        macos)
            echo "macos-arm64e-arm64-x86_64"
            ;;
        tvos)
            echo "tvos-arm64-x86_64-simulator"
            ;;
        watchos)
            echo "watchos-arm64-x86_64-simulator"
            ;;
        *)
            echo "${platform}-simulator"
            ;;
    esac
}

# Function to get framework directory abbreviation
get_framework_dir() {
    case "$1" in
        AttributeGraph)
            echo "AG"
            ;;
        RenderBox)
            echo "RB"
            ;;
        CoreUI)
            echo "CoreUI"
            ;;
        *)
            echo "$1"
            ;;
    esac
}

# Function to process a single framework
process_framework() {
    local framework_name="$1"
    local framework_dir=$(get_framework_dir "$framework_name")
    local platform_dir=$(get_platform_dir "$PLATFORM")
    
    echo "Processing ${framework_name} for ${PLATFORM}..."
    
    # Check if framework exists in runtime
    if [ ! -d "${PRIVATE_FRAMEWORKS}/${framework_name}.framework" ]; then
        echo "Warning: ${framework_name}.framework not found in ${PRIVATE_FRAMEWORKS}"
        return 1
    fi
    
    # Copy framework to tmp
    echo "  - Copying framework to /tmp..."
    cp -r "${PRIVATE_FRAMEWORKS}/${framework_name}.framework" "/tmp/${framework_name}-${PLATFORM}.framework"
    
    # Generate TBD using tapi
    echo "  - Generating TBD file..."
    cd /tmp
    xcrun tapi stubify "./${framework_name}-${PLATFORM}.framework"
    cd - > /dev/null
    
    # Create target directory
    local target_dir="${PARENT_DIR}/${framework_dir}/2024/tbds/${platform_dir}"
    mkdir -p "$target_dir"
    
    # Copy TBD file
    echo "  - Copying TBD file to ${target_dir}..."
    cp "/tmp/${framework_name}-${PLATFORM}.framework/${framework_name}.tbd" "${target_dir}/${framework_name}.tbd"
    
    # Copy and convert Info.plist to XML
    echo "  - Copying and converting Info.plist to XML format..."
    cp "/tmp/${framework_name}-${PLATFORM}.framework/Info.plist" "${target_dir}/Info.plist"
    plutil -convert xml1 "${target_dir}/Info.plist"
    
    # Clean up tmp files
    rm -rf "/tmp/${framework_name}-${PLATFORM}.framework"
    
    echo "  ✓ ${framework_name} processed successfully"
    echo ""
}

# Function to update the update.sh script
update_script() {
    local framework_dir="$1"
    local platform_dir="$2"
    local update_script="${PARENT_DIR}/${framework_dir}/update.sh"
    
    if [ ! -f "$update_script" ]; then
        echo "Warning: ${update_script} not found, skipping script update"
        return 1
    fi
    
    # Check if platform support already exists
    if grep -q "$platform_dir" "$update_script"; then
        echo "  - ${PLATFORM} support already exists in ${update_script}"
        return 0
    fi
    
    echo "  - Updating ${update_script} with ${PLATFORM} support..."
    
    # For AttributeGraph, the update is more complex due to swiftinterface generation
    if [ "$framework_dir" = "AG" ] && [ "$PLATFORM" = "xros" ]; then
        # Special handling for AG's swiftinterface generation
        echo "    Note: AttributeGraph with ${PLATFORM} requires manual update for swiftinterface generation"
        echo "    Add the following to ${update_script}:"
        echo ""
        echo "# Add ${PLATFORM} support if available"
        echo "if [ -n \"\$XROS_VERSION\" ] && [ -d \"\${FRAMEWORK_ROOT}/tbds/${platform_dir}\" ]; then"
        echo "    generate_framework \$framework_name ${platform_dir}"
        echo "    generate_swiftinterface x86_64-apple-xros-simulator x86_64-apple-xros\${XROS_VERSION}-simulator"
        echo "    generate_swiftinterface arm64-apple-xros-simulator arm64-apple-xros\${XROS_VERSION}-simulator"
        echo "    rm template.swiftinterface"
        echo "fi"
    else
        # For other frameworks or platforms, add simple framework generation
        # Find the last generate_framework line and add after it
        local last_generate_line=$(grep -n "generate_framework.*macos-arm64e-arm64-x86_64" "$update_script" | tail -1 | cut -d: -f1)
        if [ -n "$last_generate_line" ]; then
            sed -i '' "${last_generate_line}a\\
\\
# Add ${PLATFORM} support if available\\
if [ -d \"\${FRAMEWORK_ROOT}/tbds/${platform_dir}\" ]; then\\
    generate_framework \$framework_name ${platform_dir}\\
fi" "$update_script"
        fi
    fi
}

# Function to update README
update_readme() {
    local framework_dir="$1"
    local readme="${PARENT_DIR}/${framework_dir}/README.md"
    
    if [ ! -f "$readme" ]; then
        echo "Warning: ${readme} not found, skipping README update"
        return 1
    fi
    
    # Check if platform instructions already exist
    if grep -q "${PLATFORM}" "$readme"; then
        echo "  - ${PLATFORM} instructions already exist in ${readme}"
        return 0
    fi
    
    echo "  - Updating ${readme} with ${PLATFORM} instructions..."
    
    # Get platform display name
    local platform_name=""
    case "$PLATFORM" in
        ios)
            platform_name="iOS"
            ;;
        xros)
            platform_name="visionOS"
            ;;
        macos)
            platform_name="macOS"
            ;;
        tvos)
            platform_name="tvOS"
            ;;
        watchos)
            platform_name="watchOS"
            ;;
        *)
            platform_name="$PLATFORM"
            ;;
    esac
    
    # Add platform instructions
    echo "" >> "$readme"
    echo "- ${platform_name} Simulator:" >> "$readme"
    echo "    - \`${PRIVATE_FRAMEWORKS}/<framework>.framework\`" >> "$readme"
    echo "    - \`xcrun tapi stubify ./<framework>.framework\`" >> "$readme"
}

# Process each framework
for framework in "$@"; do
    process_framework "$framework"
    
    # Get framework directory and platform directory
    framework_dir=$(get_framework_dir "$framework")
    platform_dir=$(get_platform_dir "$PLATFORM")
    
    # Update scripts and README
    update_script "$framework_dir" "$platform_dir"
    update_readme "$framework_dir"
done

echo "All frameworks processed successfully for ${PLATFORM}!"
echo ""
echo "Next steps:"
echo "1. Review the generated TBD files in each framework's tbds/${platform_dir} directory"
echo "2. Run the update.sh script in each framework directory to generate the xcframework"
if [ "$PLATFORM" = "xros" ] && [[ " $@ " =~ " AttributeGraph " ]]; then
    echo "3. For AttributeGraph with visionOS, you may need to manually update the script for swiftinterface generation"
fi
echo ""
echo "Claude command for automated processing:"
echo "claude: Please generate ${PLATFORM} TBD files for $@ from the runtime at '$RUNTIME_BASE', update their generation scripts and READMEs accordingly."