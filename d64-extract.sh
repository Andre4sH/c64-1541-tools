I ha#!/usr/bin/env bash

set -eu

usage() {
    echo "Usage: $0 <d64-image> <file-in-image> [output-file]" >&2
    exit 1
}

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    usage
fi

image_path=$1
file_in_image=$2
output_path=${3:-$file_in_image}

if [ ! -f "$image_path" ]; then
    echo "D64 image not found: $image_path" >&2
    exit 1
fi

if ! command -v c1541 >/dev/null 2>&1; then
    echo "c1541 is not installed or not in PATH" >&2
    exit 1
fi

c1541 -attach "$image_path" -read "$file_in_image" "$output_path"