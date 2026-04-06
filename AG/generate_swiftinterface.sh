#!/bin/bash

## Generate template.swiftinterface from DeviceSwiftShims sources.
##
## This compiles the DeviceSwiftShims Swift files against the AttributeGraph xcframework
## to produce a .swiftinterface, then transforms it into the template used by update.sh:
##   1. Strip the compiler header comments (update.sh generates per-platform headers)

# A `realpath` alternative using the default C implementation.
filepath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

SCRIPT_DIR="$(dirname "$(filepath "$0")")"
VERSION=${DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE:-2024}
FRAMEWORK_ROOT="${SCRIPT_DIR}/${VERSION}"
SHIMS_DIR="${SCRIPT_DIR}/DeviceSwiftShims"
TEMPLATE_PATH="${FRAMEWORK_ROOT}/Sources/Modules/AttributeGraph.swiftmodule/template.swiftinterface"

TMPDIR_WORK=$(mktemp -d)
trap "rm -rf ${TMPDIR_WORK}" EXIT

GENERATED="${TMPDIR_WORK}/generated.swiftinterface"

# Resolve the iOS Simulator SDK version for the -target flag
IOS_SDK_VERSION=$(xcrun --sdk iphonesimulator --show-sdk-version)

# Compile DeviceSwiftShims against the simulator xcframework to emit a swiftinterface
xcrun --sdk iphonesimulator swiftc \
    -emit-module-interface-path "${GENERATED}" \
    -emit-module-path "${TMPDIR_WORK}/module.swiftmodule" \
    -module-name AttributeGraph \
    -enable-library-evolution \
    -swift-version 5 \
    -Osize \
    -enable-upcoming-feature InternalImportsByDefault \
    -enable-experimental-feature Extern \
    -target "arm64-apple-ios${IOS_SDK_VERSION}-simulator" \
    -F "${FRAMEWORK_ROOT}/AttributeGraph.xcframework/ios-arm64-x86_64-simulator/" \
    $(find "${SHIMS_DIR}" -name '*.swift') \
    2>/dev/null

if [ ! -f "${GENERATED}" ]; then
    echo "Error: failed to generate swiftinterface"
    exit 1
fi

# Strip the compiler header comments (update.sh generates per-platform headers)
sed -e '/^\/\/ swift-/d' \
    "${GENERATED}" > "${TEMPLATE_PATH}"

echo "Generated: ${TEMPLATE_PATH}"
