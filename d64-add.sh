#!/usr/bin/env bash

set -eu

usage() {
    echo "Usage: $0 <image.d64> <file> [cbm-name]" >&2
    echo "" >&2
    echo "  image.d64  Path to the existing D64 image file" >&2
    echo "  file       Local file to append to the disk image" >&2
    echo "  cbm-name   Name to use on the disk (default: basename of file)" >&2
    exit 1
}

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    usage
fi

image_path=$1
local_file=$2
cbm_name=${3:-$(basename "$local_file")}

if [ ! -f "$image_path" ]; then
    echo "D64 image not found: $image_path" >&2
    exit 1
fi

if [ ! -f "$local_file" ]; then
    echo "File not found: $local_file" >&2
    exit 1
fi

if ! command -v c1541 >/dev/null 2>&1; then
    echo "c1541 is not installed or not in PATH" >&2
    exit 1
fi

c1541 -attach "$image_path" -write "$local_file" "$cbm_name"
echo "Appended '$local_file' to '$image_path' as '$cbm_name'"
