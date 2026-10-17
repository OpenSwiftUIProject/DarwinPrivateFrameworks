#!/bin/bash
#
# Generate device tbd files from the dyld shared cache of a device firmware.
#
# The script extracts each framework from the cache with ipsw, writes its tbd
# with `tapi stubify --no-compact`, and adds the arm64 target. The cache holds
# arm64e binaries, but third-party apps link the arm64 slice.
#
# Requirements: ipsw (https://github.com/blacktop/ipsw), Xcode, python3.
#
# Prepare the cache from a firmware IPSW. See "Device tbd Files" in README.md.
#   ipsw download ipsw --device RealityDevice14,1 --build 22O473 -o <firmware-dir>
#   ipsw extract --dyld -a arm64e -o <cache-dir> <firmware-dir>/<firmware>.ipsw

set -euo pipefail

usage() {
    echo "Usage: $0 <platform> <dyld_shared_cache> <framework_name> [<framework_name> ...]"
    echo "  platform: xros"
    echo "  dyld_shared_cache: path to dyld_shared_cache_arm64e from the device firmware"
    echo ""
    echo "Example:"
    echo "  $0 xros \"<dir>/22O473__RealityDevice14,1/dyld_shared_cache_arm64e\" AttributeGraph RenderBox CoreUI"
}

if [[ $# -lt 3 ]]; then
    usage >&2
    exit 1
fi

PLATFORM="$1"
CACHE="$2"
shift 2

case "$PLATFORM" in
    xros)
        PLATFORM_DIR="xros-arm64-arm64e"
        ;;
    *)
        echo "Error: Unsupported platform: $PLATFORM" >&2
        exit 1
        ;;
esac

if [[ ! -f "$CACHE" ]]; then
    echo "Error: dyld shared cache not found: $CACHE" >&2
    exit 1
fi
if ! command -v ipsw > /dev/null; then
    echo "Error: ipsw is not installed. Install it with: brew install blacktop/tap/ipsw" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

get_framework_dir() {
    case "$1" in
        AttributeGraph) echo "AG" ;;
        RenderBox) echo "RB" ;;
        BacklightServices) echo "BLS" ;;
        Gestures) echo "GF" ;;
        *) echo "$1" ;;
    esac
}

for framework_name in "$@"; do
    framework_dir="$(get_framework_dir "$framework_name")"
    target_dir="$REPO_ROOT/$framework_dir/2024/tbds/$PLATFORM_DIR"
    echo "Processing $framework_name for $PLATFORM..."

    ipsw dyld extract "$CACHE" "$framework_name" -o "$WORK_DIR/extract" --force > /dev/null
    binary="$WORK_DIR/extract/$framework_name"
    if [[ ! -f "$binary" ]]; then
        echo "Error: $framework_name is not in the dyld shared cache" >&2
        exit 1
    fi

    framework="$WORK_DIR/$framework_name.framework"
    mkdir -p "$framework"
    cp "$binary" "$framework/$framework_name"
    (cd "$WORK_DIR" && xcrun tapi stubify --no-compact "./$framework_name.framework")

    mkdir -p "$target_dir"
    # Add the arm64 target after each arm64e target and keep the
    # `tapi stubify --no-compact` layout.
    python3 - "$framework/$framework_name.tbd" "$target_dir/$framework_name.tbd" <<'PYTHON'
import json
import sys

source, destination = sys.argv[1], sys.argv[2]
with open(source) as file:
    stub = json.load(file)
library = stub["main_library"]
targets = []
for info in library["target_info"]:
    targets.append(info)
    if info["target"].startswith("arm64e-"):
        arm64 = dict(info)
        arm64["target"] = "arm64-" + info["target"][len("arm64e-"):]
        if all(existing["target"] != arm64["target"] for existing in library["target_info"]):
            targets.append(arm64)
library["target_info"] = targets

# Sections that list their own targets apply to arm64 as well.
def add_arm64(node):
    if isinstance(node, dict):
        names = node.get("targets")
        if isinstance(names, list):
            for name in list(names):
                if name.startswith("arm64e-") and "arm64-" + name[len("arm64e-"):] not in names:
                    names.insert(names.index(name) + 1, "arm64-" + name[len("arm64e-"):])
        for value in node.values():
            add_arm64(value)
    elif isinstance(node, list):
        for value in node:
            add_arm64(value)

add_arm64(library)
with open(destination, "w") as file:
    json.dump(stub, file, indent=2)
    file.write("\n")
PYTHON

    echo "  ✓ $target_dir/$framework_name.tbd"
done
