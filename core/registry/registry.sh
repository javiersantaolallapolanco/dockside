#!/bin/sh

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
ROOT_DIR="$(CDPATH= cd -- "$SELF_DIR/../.." && pwd)"

registry_find() {
    namespace="$1"
    command="$2"

    candidate="$ROOT_DIR/core/$namespace/$command/run.sh"

    if [ -f "$candidate" ]; then
        printf '%s\n' "$candidate"
        return 0
    fi

    return 1
}
