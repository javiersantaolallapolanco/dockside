#!/bin/sh

dockside_source() {
    file="$1"

    if [ ! -f "$file" ]; then
        printf '%s\n' "ERROR: cannot load file: $file" >&2
        exit 1
    fi

    . "$file"
}
