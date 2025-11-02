#!/bin/bash

# Script to run update.sh for specified frameworks
# Usage: ./update_frameworks.sh [framework1] [framework2] ... or "all"
# Example: ./update_frameworks.sh AttributeGraph RenderBox CoreUI
# Example: ./update_frameworks.sh all

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PARENT_DIR="$(dirname "$SCRIPT_DIR")"

# Set default version if not specified
VERSION=${DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE:-2024}

# Function to get framework directory abbreviation
get_framework_dir() {
    case "$1" in
        AttributeGraph|AG)
            echo "AG"
            ;;
        RenderBox|RB)
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

# Function to update a single framework
update_framework() {
    local framework_name="$1"
    local framework_dir=$(get_framework_dir "$framework_name")
    local update_script="${PARENT_DIR}/${framework_dir}/update.sh"
    
    if [ ! -f "$update_script" ]; then
        echo "❌ Error: update.sh not found for ${framework_name} at ${update_script}"
        return 1
    fi
    
    echo "📦 Updating ${framework_name} (${framework_dir})..."
    echo "  Using version: ${VERSION}"
    
    # Change to framework directory and run update.sh
    cd "${PARENT_DIR}/${framework_dir}"
    
    # Run the update script with the specified version
    DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE=${VERSION} ./update.sh
    
    if [ $? -eq 0 ]; then
        echo "✅ ${framework_name} updated successfully"
    else
        echo "❌ Failed to update ${framework_name}"
        return 1
    fi
    
    # Return to original directory
    cd - > /dev/null
    echo ""
}

# Main execution
if [ $# -eq 0 ]; then
    echo "Usage: $0 [framework1] [framework2] ... or 'all'"
    echo "Examples:"
    echo "  $0 AttributeGraph RenderBox CoreUI"
    echo "  $0 all"
    echo ""
    echo "Frameworks: AttributeGraph (or AG), RenderBox (or RB), CoreUI"
    echo ""
    echo "To specify version, set DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE:"
    echo "  DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE=2021 $0 all"
    exit 1
fi

# Check if "all" was specified
if [ "$1" = "all" ]; then
    frameworks=("AttributeGraph" "RenderBox" "CoreUI")
else
    frameworks=("$@")
fi

echo "🚀 Starting framework updates..."
echo "================================"
echo ""

# Track success
all_success=true

# Update each framework
for framework in "${frameworks[@]}"; do
    if ! update_framework "$framework"; then
        all_success=false
    fi
done

echo "================================"
if [ "$all_success" = true ]; then
    echo "✅ All frameworks updated successfully!"
else
    echo "⚠️  Some frameworks failed to update"
    exit 1
fi