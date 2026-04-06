#!/bin/bash

## xcframework does not support soft link header file, so we use this script to simplify the process.

# A `realpath` alternative using the default C implementation.
filepath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

VERSION=${DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE:-2025}
FRAMEWORK_ROOT="$(dirname $(filepath $0))/$VERSION"

IOS_VERSION="26.0"
MACOS_VERSION="26.0"

framework_name=Gestures

generate_swiftinterface_header() {
    local target="$1"
    local result=""
    result+="// swift-interface-format-version: 1.0\n"
    result+="// swift-compiler-version: Apple Swift version 6.2 effective-5.10 (swiftlang-6.2.0.16.112 clang-1800.1.29)\n"
    result+="// swift-module-flags: -target $target -enable-objc-interop -enable-library-evolution -swift-version 5 -Osize -enable-upcoming-feature InternalImportsByDefault -enable-experimental-feature Extern -module-name Gestures\n"
    result+="// swift-module-flags-ignorable:  -interface-compiler-version 6.2"

    echo -e $result
}

generate_swiftinterface() {
  local name="$1".swiftinterface
  local target="$2"
  generate_swiftinterface_header $target > $name
  cat template.swiftinterface >> $name
}

update_version_in_header() {
    local file="$1"
    local version="$2"
    sed -i '' "s/#define GESTURES_RELEASE [0-9]\{4\}/#define GESTURES_RELEASE ${version}/g" "$file"
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

    update_version_in_header "${path}/Headers/GFVersion.h" "${VERSION}"
}

generate_xcframework() {
    local framework_name=$1

    local path="${FRAMEWORK_ROOT}/${framework_name}.xcframework"
    mkdir -p ${path}
    cp ${FRAMEWORK_ROOT}/Info.plist ${path}/
}

generate_xcframework $framework_name

generate_framework $framework_name ios-arm64-arm64e
# iPhoneOS platform does not support linking Swift API of Gestures
cd ${FRAMEWORK_ROOT}/${framework_name}.xcframework/ios-arm64-arm64e/${framework_name}.framework/Modules
rm -r ./$framework_name.swiftmodule

generate_framework $framework_name ios-arm64-x86_64-simulator
cd ${FRAMEWORK_ROOT}/${framework_name}.xcframework/ios-arm64-x86_64-simulator/${framework_name}.framework/Modules/${framework_name}.swiftmodule
generate_swiftinterface x86_64-apple-ios-simulator x86_64-apple-ios${IOS_VERSION}-simulator
generate_swiftinterface arm64-apple-ios-simulator arm64-apple-ios${IOS_VERSION}-simulator
rm template.swiftinterface

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

    update_version_in_header "${path}/Versions/A/Headers/GFVersion.h" "${VERSION}"

    cd ${path}
    ln -sf Versions/Current/Headers Headers
    ln -sf Versions/Current/Modules Modules
    ln -sf Versions/Current/Resources Resources
    ln -sf Versions/Current/${framework_name}.tbd ${framework_name}.tbd
}

generate_macos_framework $framework_name macos-arm64e-arm64-x86_64
cd ${FRAMEWORK_ROOT}/${framework_name}.xcframework/macos-arm64e-arm64-x86_64/${framework_name}.framework/Modules/${framework_name}.swiftmodule
generate_swiftinterface x86_64-apple-macos x86_64-apple-macos${MACOS_VERSION}
generate_swiftinterface arm64-apple-macos arm64-apple-macos${MACOS_VERSION}
generate_swiftinterface arm64e-apple-macos arm64e-apple-macos${MACOS_VERSION}
rm template.swiftinterface
