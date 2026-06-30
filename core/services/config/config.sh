#!/bin/sh

config_get() {

    key="$1"
    file="$2"

    if [ ! -f "$file" ]; then
        return 1
    fi

    grep "^${key}=" "$file" | head -n1 | cut -d= -f2-
}

config_require() {

    key="$1"
    file="$2"

    value="$(config_get "$key" "$file")"

    if [ -z "$value" ]; then
        printf '%s\n' "Missing configuration: $key"
        return 1
    fi

    printf '%s\n' "$value"
}
