#!/bin/sh

runtime_compose_exists() {
    docker compose version >/dev/null 2>&1
}

runtime_compose_load_env() {
    env_file="$1"

    if [ -z "$env_file" ] || [ ! -f "$env_file" ]; then
        return 0
    fi

    set -a
    . "$env_file"
    set +a
}

runtime_compose_run() {
    env_file="$1"
    compose_file="$2"
    shift 2

    if [ -n "$env_file" ] && [ -f "$env_file" ]; then
        runtime_compose_load_env "$env_file"
        docker compose --env-file "$env_file" -f "$compose_file" "$@"
    else
        docker compose -f "$compose_file" "$@"
    fi
}
