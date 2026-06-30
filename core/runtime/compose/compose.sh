#!/bin/sh

runtime_compose_exists() {
    docker compose version >/dev/null 2>&1
}

runtime_compose_run() {
    env_file="$1"
    compose_file="$2"
    shift 2

    if [ -n "$env_file" ] && [ -f "$env_file" ]; then
        docker compose --env-file "$env_file" -f "$compose_file" "$@"
    else
        docker compose -f "$compose_file" "$@"
    fi
}
