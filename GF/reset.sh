#!/bin/bash

# A `realpath` alternative using the default C implementation.
filepath() {
  [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

VERSION=${DARWINPRIVATEFRAMEWORKS_TARGET_RELEASE:-2025}
FRAMEWORK_ROOT="$(dirname $(filepath $0))/$VERSION"

framework_name=Gestures

rm -rf ${FRAMEWORK_ROOT}/${framework_name}.xcframework
