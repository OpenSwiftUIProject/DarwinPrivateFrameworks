#!/bin/bash

## Generate template.swiftinterface from DeviceSwiftShims sources.
##
## This compiles the DeviceSwiftShims Swift files against the Gestures xcframework
## to produce a .swiftinterface, then transforms it into the template used by update.sh:
##   1. Strip the compiler header comments (update.sh generates per-platform headers)
##   2. Remove `Gestures.` module prefix from extension type names

# A `realpath` alternative using the default C implementation.
filepath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

SCRIPT_DIR="$(dirname "$(filepath "$0")")"
PACKAGE_DIR="$(dirname "${SCRIPT_DIR}")"
VERSION=${DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE:-2025}
FRAMEWORK_ROOT="${SCRIPT_DIR}/${VERSION}"
SHIMS_DIR="${SCRIPT_DIR}/DeviceSwiftShims"
TEMPLATE_PATH="${FRAMEWORK_ROOT}/Sources/Modules/Gestures.swiftmodule/template.swiftinterface"

# Verify Swift compiler version matches the expected version for this framework
EXPECTED_SWIFT_VERSION="6.2" # 2024 -> 6.1, 2025 -> 6.2
SWIFT_VERSION=$(xcrun swiftc --version 2>&1 | grep -o 'Swift version [0-9]*\.[0-9]*' | head -1 | awk '{print $3}')
if [ "${SWIFT_VERSION}" != "${EXPECTED_SWIFT_VERSION}" ]; then
    echo "Error: expected Swift ${EXPECTED_SWIFT_VERSION} but found Swift ${SWIFT_VERSION}"
    echo "Set DEVELOPER_DIR to the correct Xcode version"
    exit 1
fi

# Build package dependencies (OrderedCollections etc.) via SPM
swift build --package-path "${PACKAGE_DIR}" --target _GesturesDeviceSwiftShims 2>/dev/null
if [ $? -ne 0 ]; then
    echo "Error: failed to build package dependencies"
    exit 1
fi

# Locate the SPM modules directory for import search paths
BUILD_BIN_PATH=$(swift build --package-path "${PACKAGE_DIR}" --show-bin-path 2>/dev/null)
MODULES_DIR="${BUILD_BIN_PATH}/Modules"

TMPDIR_WORK=$(mktemp -d)
trap "rm -rf ${TMPDIR_WORK}" EXIT

GENERATED="${TMPDIR_WORK}/generated.swiftinterface"

# Use macOS SDK to match the host-built SPM modules
MACOS_SDK_VERSION=$(xcrun --sdk macosx --show-sdk-version)

# Compile DeviceSwiftShims against the macOS xcframework to emit a swiftinterface
xcrun --sdk macosx swiftc \
    -emit-module-interface-path "${GENERATED}" \
    -emit-module-path "${TMPDIR_WORK}/module.swiftmodule" \
    -module-name Gestures \
    -package-name Gestures \
    -enable-library-evolution \
    -swift-version 5 \
    -Osize \
    -enable-upcoming-feature InternalImportsByDefault \
    -enable-experimental-feature Extern \
    -target "arm64-apple-macos${MACOS_SDK_VERSION}" \
    -F "${FRAMEWORK_ROOT}/Gestures.xcframework/macos-arm64e-arm64-x86_64/" \
    -I "${MODULES_DIR}" \
    $(find "${SHIMS_DIR}" -name '*.swift') \
    2>/dev/null

if [ ! -f "${GENERATED}" ]; then
    echo "Error: failed to generate swiftinterface"
    exit 1
fi

# Transform:
#   1. Strip the compiler header comments (update.sh generates per-platform headers)
#   2. Remove `Gestures.` module prefix from extension declarations
sed -e '/^\/\/ swift-/d' \
    -e 's/extension Gestures\./extension /g' \
    "${GENERATED}" > "${TEMPLATE_PATH}"

echo "Generated: ${TEMPLATE_PATH}"
