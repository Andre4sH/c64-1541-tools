#!/usr/bin/env bash

set -eu

usage() {
    echo "Usage: $0 <image.d64> <file-in-image>" >&2
    echo "" >&2
    echo "  image.d64      Path to the D64 image file" >&2
    echo "  file-in-image  Name of the file to remove from the disk image" >&2
    exit 1
}

if [ "$#" -ne 2 ]; then
    usage
fi

image_path=$1
file_in_image=$2

if [ ! -f "$image_path" ]; then
    echo "D64 image not found: $image_path" >&2
    exit 1
fi

if ! command -v c1541 >/dev/null 2>&1; then
    echo "c1541 is not installed or not in PATH" >&2
    exit 1
fi

c1541 -attach "$image_path" -delete "$file_in_image"
echo "Removed '$file_in_image' from $image_path"
