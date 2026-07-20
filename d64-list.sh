#!/usr/bin/env bash

set -eu

usage() {
    echo "Usage: $0 <image.d64> [filter]" >&2
    echo "" >&2
    echo "  image.d64  Path to the D64 image file" >&2
    echo "  filter     Optional filename filter, supports wildcards (e.g. *.prg)" >&2
    exit 1
}

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    usage
fi

image_path=$1
filter=${2:-}

if [ ! -f "$image_path" ]; then
    echo "D64 image not found: $image_path" >&2
    exit 1
fi

if ! command -v c1541 >/dev/null 2>&1; then
    echo "c1541 is not installed or not in PATH" >&2
    exit 1
fi

if [ -n "$filter" ]; then
    # Convert wildcard pattern to a grep-compatible regex:
    # escape dots, then replace * with .* and ? with .
    pattern=$(echo "$filter" | sed 's/\./\\./g; s/\*/.*/g; s/?/./g')
    c1541 -attach "$image_path" -list 2>/dev/null | grep -i "$pattern" || true
else
    c1541 -attach "$image_path" -list
fi
