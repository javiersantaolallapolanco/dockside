#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DOCKSIDE_ROOT="$(CDPATH= cd -- "$SELF_DIR/../../.." && pwd)"
export DOCKSIDE_ROOT

. "$DOCKSIDE_ROOT/core/runtime/runtime.sh"

runtime_load compose

runtime_compose_exists

echo "Compose runtime OK"
