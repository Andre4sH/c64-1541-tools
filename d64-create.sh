#!/usr/bin/env bash

set -eu

usage() {
    echo "Usage: $0 <image.d64> <diskname> [disk-id]" >&2
    echo "" >&2
    echo "  image.d64  Path to the new D64 image file to create" >&2
    echo "  diskname   Label for the disk (max 16 chars)" >&2
    echo "  disk-id    Two-character disk ID (default: 01)" >&2
    exit 1
}

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
    usage
fi

image_path=$1
if [[ "$image_path" != *.d64 ]]; then
    image_path="${image_path}.d64"
fi
diskname=$2
disk_id=${3:-01}

if ! command -v c1541 >/dev/null 2>&1; then
    echo "c1541 is not installed or not in PATH" >&2
    exit 1
fi

c1541 -format "${diskname},${disk_id}" d64 "$image_path"
echo "Created D64 image: $image_path (label: $diskname, id: $disk_id)"
