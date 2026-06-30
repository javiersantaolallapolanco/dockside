#!/bin/sh

runtime_compose_exists() {
    docker compose version >/dev/null 2>&1
}

runtime_compose() {
    compose_file="$1"
    shift

    docker compose -f "$compose_file" "$@"
}

runtime_compose_pull() {
    compose_file="$1"

    runtime_compose "$compose_file" pull
}

runtime_compose_up() {
    compose_file="$1"

    runtime_compose "$compose_file" up -d
}

runtime_compose_down() {
    compose_file="$1"

    runtime_compose "$compose_file" down
}
