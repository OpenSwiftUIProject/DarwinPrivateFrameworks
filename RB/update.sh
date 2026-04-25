#!/bin/bash

## xcframework does not support soft link header file, so we use this script to simpfy the process.

# A `realpath` alternative using the default C implementation.
filepath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

VERSION=${DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE:-2024}
FRAMEWORK_ROOT="$(dirname $(filepath $0))/$VERSION"

framework_name=RenderBox

update_version_in_header() {
    local file="$1"
    local version="$2"
    
    # Use sed to perform in-place replacement on the given file
    sed -i '' "s/#define RENDERBOX_RELEASE [0-9]\{4\}/#define RENDERBOX_RELEASE ${version}/g" "$file"
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

    update_version_in_header "${path}/Headers/RBVersion.h" "${VERSION}"
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

    update_version_in_header "${path}/Versions/A/Headers/RBVersion.h" "${VERSION}"

    cd ${path}
    ln -sf Versions/Current/Headers Headers
    ln -sf Versions/Current/Modules Modules
    ln -sf Versions/Current/Resources Resources
    ln -sf Versions/Current/${framework_name}.tbd ${framework_name}.tbd
}

generate_xcframework() {
    local framework_name=$1

    local path="${FRAMEWORK_ROOT}/${framework_name}.xcframework"
    mkdir -p ${path}
    cp ${FRAMEWORK_ROOT}/Info.plist ${path}/
}

generate_xcframework $framework_name

generate_framework $framework_name ios-arm64-x86_64-simulator
generate_framework $framework_name ios-arm64-arm64e
generate_macos_framework $framework_name macos-arm64e-arm64-x86_64

# Add visionOS support if available
if [ -d "${FRAMEWORK_ROOT}/tbds/xros-arm64-x86_64-simulator" ]; then
    generate_framework $framework_name xros-arm64-x86_64-simulator
fi
