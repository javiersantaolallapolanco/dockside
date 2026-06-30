#!/bin/sh

command_run() {
    command="$1"

    script="$DOCKSIDE_ROOT/core/commands/$command/run.sh"

    if [ ! -f "$script" ]; then
        printf '%s\n' "ERROR: command not found: $command" >&2
        exit 1
    fi

    shift

    . "$script"
}
