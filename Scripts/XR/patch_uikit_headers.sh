#!/bin/bash
#
# Remove the visionOS availability restrictions that block UIScreen use in a
# UIKit headers directory: every restriction in UIScreen.h, the UIWindow.screen
# property in UIWindow.h, and the UIDevice.orientation property in UIDevice.h.
# The directory must be a writable copy; the script never touches an SDK inside
# Xcode on its own.

set -euo pipefail

usage() {
    echo "Usage: $0 <uikit-headers-dir>"
    echo "Remove the visionOS restrictions from UIScreen.h, UIWindow.screen, and UIDevice.orientation in place."
    echo "The directory must contain UIScreen.h, UIWindow.h, and UIDevice.h."
}

if [[ $# -ne 1 ]]; then
    usage >&2
    exit 1
fi

HEADERS_DIR="$1"
UISCREEN_H="$HEADERS_DIR/UIScreen.h"
UIWINDOW_H="$HEADERS_DIR/UIWindow.h"
UIDEVICE_H="$HEADERS_DIR/UIDevice.h"

for header in "$UISCREEN_H" "$UIWINDOW_H" "$UIDEVICE_H"; do
    if [[ ! -f "$header" ]]; then
        echo "Error: Missing header: $header" >&2
        exit 1
    fi
    if [[ ! -w "$header" ]]; then
        echo "Error: Header is not writable: $header" >&2
        exit 1
    fi
done

# Count the lines of a header that match an extended regular expression.
# grep exits 1 for zero matches and 2 or more for a real error.
count_lines() {
    local count status=0
    count="$(grep -c -E "$2" "$1")" || status=$?
    if [[ $status -gt 1 ]]; then
        echo "Error: grep failed on $1" >&2
        return "$status"
    fi
    echo "$count"
}

# Remove visionos from every API_UNAVAILABLE list in UIScreen.h:
# 1. visionos is the only platform: drop the macro.
# 2. visionos is first: drop it with the following comma.
# 3. visionos is in the middle or last: drop it with the preceding comma.
STRIP_VISIONOS='
    s/\s*\bAPI_UNAVAILABLE\(\s*visionos\s*\)//g;
    s/\bAPI_UNAVAILABLE\(\s*visionos\s*,\s*/API_UNAVAILABLE(/g;
    s/(\bAPI_UNAVAILABLE\([^)]*?),\s*visionos\b\s*(?=[,)])/$1/g;
'
VISIONOS_PATTERN='API_UNAVAILABLE\([^)]*\bvisionos\b'

before="$(count_lines "$UISCREEN_H" "$VISIONOS_PATTERN")"
if [[ "$before" -eq 0 ]]; then
    echo "Error: UIScreen.h has no visionos restrictions to remove: $UISCREEN_H" >&2
    exit 1
fi
perl -pi -e "$STRIP_VISIONOS" "$UISCREEN_H"
after="$(count_lines "$UISCREEN_H" "$VISIONOS_PATTERN")"
if [[ "$after" -ne 0 ]]; then
    echo "Error: UIScreen.h still has visionos restrictions on $after lines: $UISCREEN_H" >&2
    exit 1
fi
echo "Patched UIScreen.h: removed visionos restrictions on $before lines"

# Remove visionos from the API_UNAVAILABLE list of exactly one property
# declaration. $2 is a regular expression for the declaration up to the name,
# $3 is the name used in messages.
enable_property() {
    local header="$1" declaration="$2" name="$3"
    local pattern="${declaration}[^;]*${VISIONOS_PATTERN}"
    local count
    count="$(count_lines "$header" "$pattern")"
    if [[ "$count" -ne 1 ]]; then
        echo "Error: Expected one $name declaration with a visionos restriction, found $count: $header" >&2
        exit 1
    fi
    DECLARATION="$declaration" perl -pi -e '
        next unless /$ENV{DECLARATION}/;
        s/\s*\bAPI_UNAVAILABLE\(\s*visionos\s*\)//g;
        s/\bAPI_UNAVAILABLE\(\s*visionos\s*,\s*/API_UNAVAILABLE(/g;
        s/(\bAPI_UNAVAILABLE\([^)]*?),\s*visionos\b\s*(?=[,)])/$1/g;
    ' "$header"
    count="$(count_lines "$header" "$pattern")"
    if [[ "$count" -ne 0 ]]; then
        echo "Error: $name is still restricted: $header" >&2
        exit 1
    fi
    echo "Patched $(basename "$header"): enabled $name on visionOS"
}

enable_property "$UIWINDOW_H" 'UIScreen \*screen\b' "UIWindow.screen"
enable_property "$UIDEVICE_H" 'UIDeviceOrientation orientation\b' "UIDevice.orientation"
