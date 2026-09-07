#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION=${DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE:-2024}
if [[ "$VERSION" != "2024" ]]; then
    echo "FeatureFlags supports release 2024." >&2
    exit 1
fi
rm -rf "$SCRIPT_DIR/$VERSION/FeatureFlags.xcframework"
