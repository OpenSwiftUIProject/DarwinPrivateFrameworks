#!/bin/bash

## xcframework does not support soft link header file, so we use this script to simpfy the process.

# A `realpath` alternative using the default C implementation.
filepath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

VERSION=${DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE:-2024}
SCRIPT_DIR="$(dirname "$(filepath "$0")")"
FRAMEWORK_ROOT="${SCRIPT_DIR}/${VERSION}"
TEMPLATE_PATH="${FRAMEWORK_ROOT}/Sources/Modules/AttributeGraph.swiftmodule/template-${VERSION}.swiftinterface"

# Version mapping logic
if [ "$VERSION" = "2021" ]; then
    IOS_VERSION="15.0"
    MACOS_VERSION="12.0"
    XROS_VERSION=""  # visionOS not available in 2021
elif [ "$VERSION" = "2024" ]; then
    IOS_VERSION="18.0"
    MACOS_VERSION="15.0"
    XROS_VERSION="2.0"
else
    IOS_VERSION="18.0"
    MACOS_VERSION="15.0"
    XROS_VERSION="2.0"
fi

framework_name=AttributeGraph

generate_swiftinterface_header() {
    local target="$1"
    local result=""
    result+="// swift-interface-format-version: 1.0\n"
    result+="// swift-compiler-version: Apple Swift version 6.1 effective-5.10 (swiftlang-6.1.0.110.21 clang-1700.0.13.3)\n"
    result+="// swift-module-flags: -target $target -enable-objc-interop -enable-library-evolution -swift-version 5 -Osize -enable-upcoming-feature InternalImportsByDefault -enable-experimental-feature Extern -module-name AttributeGraph\n"
    result+="// swift-module-flags-ignorable:  -interface-compiler-version 6.1"

    echo -e $result
}

generate_swiftinterface() {
  local name="$1".swiftinterface
  local target="$2"
  generate_swiftinterface_header $target > $name
  cat "${TEMPLATE_PATH}" >> $name
}

update_version_in_header() {
    local file="$1"
    local version="$2"
    
    # Use sed to perform in-place replacement on the given file
    sed -i '' "s/#define ATTRIBUTEGRAPH_RELEASE [0-9]\{4\}/#define ATTRIBUTEGRAPH_RELEASE ${version}/g" "$file"
}

generate_framework() {
    local framework_name=$1
    local arch_name=$2

    local path="${FRAMEWORK_ROOT}/${framework_name}.xcframework/${arch_name}/${framework_name}.framework"
    mkdir -p ${path}

    rm -rf ${path}/${framework_name}.tbd
    rm -rf ${path}/Headers
    rm -rf ${path}/Modules
    rm -rf ${path}/Info.plist

    cp ${FRAMEWORK_ROOT}/tbds/${arch_name}/${framework_name}.tbd ${path}/
    cp -rf ${FRAMEWORK_ROOT}/Sources/Headers ${path}/
    cp -rf ${FRAMEWORK_ROOT}/Sources/Modules ${path}/
    cp -rf ${FRAMEWORK_ROOT}/Sources/Info.plist ${path}/

    update_version_in_header "${path}/Headers/AGVersion.h" "${VERSION}"

    mkdir -p ${path}/Modules/${framework_name}.swiftmodule
    cd ${path}/Modules/${framework_name}.swiftmodule
}

generate_macos_framework() {
    local framework_name=$1
    local arch_name=$2

    local path="${FRAMEWORK_ROOT}/${framework_name}.xcframework/${arch_name}/${framework_name}.framework"
    rm -rf ${path}
    mkdir -p ${path}/Versions/A/Resources

    cd ${path}/Versions
    ln -sfn A Current

    cp ${FRAMEWORK_ROOT}/tbds/${arch_name}/${framework_name}.tbd ${path}/Versions/A/
    cp -rf ${FRAMEWORK_ROOT}/Sources/Headers ${path}/Versions/A/
    cp -rf ${FRAMEWORK_ROOT}/Sources/Modules ${path}/Versions/A/
    cp ${FRAMEWORK_ROOT}/Sources/Info.plist ${path}/Versions/A/Resources/

    update_version_in_header "${path}/Versions/A/Headers/AGVersion.h" "${VERSION}"

    cd ${path}
    ln -sf Versions/Current/Headers Headers
    ln -sf Versions/Current/Modules Modules
    ln -sf Versions/Current/Resources Resources
    ln -sf Versions/Current/${framework_name}.tbd ${framework_name}.tbd

    mkdir -p ${path}/Versions/A/Modules/${framework_name}.swiftmodule
    cd ${path}/Versions/A/Modules/${framework_name}.swiftmodule
}

generate_xcframework() {
    local framework_name=$1

    local path="${FRAMEWORK_ROOT}/${framework_name}.xcframework"
    mkdir -p ${path}
    cp ${FRAMEWORK_ROOT}/Info.plist ${path}/
}

generate_xcframework $framework_name

# Regenerate template.swiftinterface from DeviceSwiftShims sources. This needs a
# bootstrap xcframework because the shims import the binary AttributeGraph target.
generate_framework $framework_name ios-arm64-x86_64-simulator

generate_framework $framework_name ios-arm64-arm64e
# iPhoneOS platform does not support links Swift API of AttributeGraph
cd ../
rm -rf ./$framework_name.swiftmodule

generate_macos_framework $framework_name macos-arm64e-arm64-x86_64

if [ -n "$XROS_VERSION" ] && [ -d "${FRAMEWORK_ROOT}/tbds/xros-arm64-x86_64-simulator" ]; then
    generate_framework $framework_name xros-arm64-x86_64-simulator
fi

if ! DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE=${VERSION} "${SCRIPT_DIR}/generate_swiftinterface.sh"; then
    echo "Error: failed to regenerate AttributeGraph Swift interface for release ${VERSION}"
    exit 1
fi

generate_framework $framework_name ios-arm64-x86_64-simulator
generate_swiftinterface x86_64-apple-ios-simulator x86_64-apple-ios${IOS_VERSION}-simulator
generate_swiftinterface arm64-apple-ios-simulator arm64-apple-ios${IOS_VERSION}-simulator
rm -f template*.swiftinterface

generate_framework $framework_name ios-arm64-arm64e
# iPhoneOS platform does not support links Swift API of AttributeGraph
cd ../
rm -rf ./$framework_name.swiftmodule

generate_macos_framework $framework_name macos-arm64e-arm64-x86_64
generate_swiftinterface x86_64-apple-macos x86_64-apple-macos${MACOS_VERSION}
generate_swiftinterface arm64-apple-macos arm64-apple-macos${MACOS_VERSION}
generate_swiftinterface arm64e-apple-macos arm64e-apple-macos${MACOS_VERSION}
rm -f template*.swiftinterface

# Add visionOS support if available
if [ -n "$XROS_VERSION" ] && [ -d "${FRAMEWORK_ROOT}/tbds/xros-arm64-x86_64-simulator" ]; then
    generate_framework $framework_name xros-arm64-x86_64-simulator
    generate_swiftinterface x86_64-apple-xros-simulator x86_64-apple-xros${XROS_VERSION}-simulator
    generate_swiftinterface arm64-apple-xros-simulator arm64-apple-xros${XROS_VERSION}-simulator
    rm -f template*.swiftinterface
fi
