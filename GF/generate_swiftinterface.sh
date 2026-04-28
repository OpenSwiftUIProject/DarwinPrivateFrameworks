#!/bin/bash

## Generate template.swiftinterface from DeviceSwiftShims sources.
##
## This compiles the DeviceSwiftShims Swift files against the Gestures xcframework
## to produce a .swiftinterface, then transforms it into the template used by update.sh:
##   1. Strip the compiler header comments (update.sh generates per-platform headers)

# A `realpath` alternative using the default C implementation.
filepath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

SCRIPT_DIR="$(dirname "$(filepath "$0")")"
PACKAGE_DIR="$(dirname "${SCRIPT_DIR}")"
VERSION=${DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE:-2025}
FRAMEWORK_ROOT="${SCRIPT_DIR}/${VERSION}"
SHIMS_DIR="${SCRIPT_DIR}/DeviceSwiftShims"
TEMPLATE_PATH="${FRAMEWORK_ROOT}/Sources/Modules/Gestures.swiftmodule/template-${VERSION}.swiftinterface"
SWIFTPM_SCRATCH_PATH=$(mktemp -d)
SWIFTPM_CACHE_PATH="${PACKAGE_DIR}/.build"
SWIFTPM_BUILD_LOG=""
SWIFTC_LOG=""
TMPDIR_WORK=""

cleanup() {
    if [ -n "${SWIFTPM_SCRATCH_PATH}" ]; then
        rm -rf "${SWIFTPM_SCRATCH_PATH}"
    fi
    if [ -n "${SWIFTPM_BUILD_LOG}" ]; then
        rm -f "${SWIFTPM_BUILD_LOG}"
    fi
    if [ -n "${SWIFTC_LOG}" ]; then
        rm -f "${SWIFTC_LOG}"
    fi
    if [ -n "${TMPDIR_WORK}" ]; then
        rm -rf "${TMPDIR_WORK}"
    fi
}
trap cleanup EXIT

# Verify Swift compiler version matches the expected version for this framework
EXPECTED_SWIFT_VERSION="6.2" # 2024 -> 6.1, 2025 -> 6.2
SWIFT_VERSION=$(xcrun swiftc --version 2>&1 | grep -o 'Swift version [0-9]*\.[0-9]*' | head -1 | awk '{print $3}')
if [ "${SWIFT_VERSION}" != "${EXPECTED_SWIFT_VERSION}" ]; then
    echo "Error: expected Swift ${EXPECTED_SWIFT_VERSION} but found Swift ${SWIFT_VERSION}"
    echo "Set DEVELOPER_DIR to the correct Xcode version"
    exit 1
fi

# Build package dependencies (OrderedCollections etc.) via SPM
# The command plugin already holds the package build lock. Use a separate
# scratch path for this nested build so update-xcframeworks does not deadlock.
SWIFTPM_BUILD_LOG=$(mktemp)
mkdir -p "${SWIFTPM_CACHE_PATH}"
if ! swift build --disable-sandbox --package-path "${PACKAGE_DIR}" --cache-path "${SWIFTPM_CACHE_PATH}" --scratch-path "${SWIFTPM_SCRATCH_PATH}" --target _GesturesDeviceSwiftShims 2>"${SWIFTPM_BUILD_LOG}"; then
    cat "${SWIFTPM_BUILD_LOG}" >&2
    echo "Error: failed to build package dependencies"
    exit 1
fi

# Locate the SPM modules directory for import search paths
if ! BUILD_BIN_PATH=$(swift build --disable-sandbox --package-path "${PACKAGE_DIR}" --cache-path "${SWIFTPM_CACHE_PATH}" --scratch-path "${SWIFTPM_SCRATCH_PATH}" --show-bin-path 2>"${SWIFTPM_BUILD_LOG}"); then
    cat "${SWIFTPM_BUILD_LOG}" >&2
    echo "Error: failed to locate package build directory"
    exit 1
fi
MODULES_DIR="${BUILD_BIN_PATH}/Modules"

TMPDIR_WORK=$(mktemp -d)
CLANG_MODULE_CACHE="${TMPDIR_WORK}/ModuleCache"
mkdir -p "${CLANG_MODULE_CACHE}"

GENERATED="${TMPDIR_WORK}/generated.swiftinterface"

# Use macOS SDK to match the host-built SPM modules
MACOS_SDK_VERSION=$(xcrun --sdk macosx --show-sdk-version)

# Compile DeviceSwiftShims against the macOS xcframework to emit a swiftinterface
SWIFTC_LOG=$(mktemp)
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
    -module-cache-path "${CLANG_MODULE_CACHE}" \
    -F "${FRAMEWORK_ROOT}/Gestures.xcframework/macos-arm64e-arm64-x86_64/" \
    -I "${MODULES_DIR}" \
    $(find "${SHIMS_DIR}" -name '*.swift') \
    2>"${SWIFTC_LOG}"

if [ ! -f "${GENERATED}" ]; then
    cat "${SWIFTC_LOG}" >&2
    echo "Error: failed to generate swiftinterface"
    exit 1
fi

# Strip the compiler header comments (update.sh generates per-platform headers)
mkdir -p "$(dirname "${TEMPLATE_PATH}")"
sed -e '/^\/\/ swift-/d' \
    "${GENERATED}" > "${TEMPLATE_PATH}"

echo "Generated: ${TEMPLATE_PATH}"
