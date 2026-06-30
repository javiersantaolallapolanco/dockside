#!/bin/sh

env_get() {
    name="$1"
    eval "value=\${$name:-}"
    printf '%s\n' "$value"
}

env_required() {
    name="$1"
    value="$(env_get "$name")"

    if [ -z "$value" ]; then
        printf '%s\n' "ERROR: required environment variable missing: $name" >&2
        exit 1
    fi

    printf '%s\n' "$value"
}
