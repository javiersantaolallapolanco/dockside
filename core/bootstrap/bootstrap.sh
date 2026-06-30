#!/bin/sh

set -eu

if [ -z "${DOCKSIDE_ROOT:-}" ]; then
    printf '%s\n' "ERROR: DOCKSIDE_ROOT is not set before bootstrap" >&2
    exit 1
fi

. "$DOCKSIDE_ROOT/stdlib/loader.sh"
. "$DOCKSIDE_ROOT/core/context/context.sh"
. "$DOCKSIDE_ROOT/core/runtime/runtime.sh"

bootstrap_init() {
    return 0
}
