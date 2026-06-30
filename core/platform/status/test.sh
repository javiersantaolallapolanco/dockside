#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DOCKSIDE_ROOT="$(CDPATH= cd -- "$SELF_DIR/../../.." && pwd)"
export DOCKSIDE_ROOT

"$DOCKSIDE_ROOT/bin/dockside" platform status

echo
echo "Platform status OK"
