#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
ROOT_DIR="$(CDPATH= cd -- "$SELF_DIR/../.." && pwd)"

. "$SELF_DIR/registry.sh"

if registry_find platform deploy >/dev/null 2>&1; then
    echo "Registry OK"
else
    echo "Registry: command not found (expected until commands exist)"
fi
