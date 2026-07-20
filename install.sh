#!/usr/bin/env bash

set -eu

if [[ "$(id -u)" -ne 0 ]]; then
    echo "Error: this script must be run as root (use sudo)" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="/usr/local/bin"

scripts=(
    "d64-extract.sh"
    "d64-create.sh"
    "d64-add.sh"
    "d64-list.sh"
    "d64-remove.sh"
)

chmod +x "${scripts[@]/#/$SCRIPT_DIR/}"

for script in "${scripts[@]}"; do
    cp "$SCRIPT_DIR/$script" "$INSTALL_DIR/$script"
    echo "Installed $script -> $INSTALL_DIR/$script"
done

echo "Done."
