#!/bin/sh

set -eu

BOOTSTRAP_SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DOCKSIDE_ROOT="$(CDPATH= cd -- "$BOOTSTRAP_SELF_DIR/../.." && pwd)"

export DOCKSIDE_ROOT

. "$DOCKSIDE_ROOT/stdlib/loader.sh"
. "$DOCKSIDE_ROOT/core/context/context.sh"
. "$DOCKSIDE_ROOT/core/runtime/runtime.sh"

bootstrap_init() {
    return 0
}
