#!/bin/sh

command_run() {
    namespace="$1"
    command="$2"

    script="$DOCKSIDE_ROOT/core/$namespace/$command/run.sh"

    if [ ! -f "$script" ]; then
        printf '%s\n' "ERROR: command not found: $namespace/$command" >&2
        exit 1
    fi

    shift 2

    . "$script"
}
