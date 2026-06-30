#!/bin/sh

if [ -z "${DOCKSIDE_ROOT:-}" ]; then
    printf '%s\n' "ERROR: DOCKSIDE_ROOT is not set" >&2
    exit 1
fi

. "$DOCKSIDE_ROOT/stdlib/loader.sh"

runtime_load() {
    module="$1"
    dockside_source "$DOCKSIDE_ROOT/core/runtime/$module/$module.sh"
}
