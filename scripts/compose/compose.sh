#!/bin/sh

. "$DOCKSIDE_HOME/scripts/core/common.sh"
. "$DOCKSIDE_HOME/scripts/core/config.sh"
. "$DOCKSIDE_HOME/scripts/core/registry.sh"

compose_env() {
    type="$1"
    name="$2"
    dir="$3"

    if [ "$type" = "app" ] && [ -f "$dir/.env" ]; then
        printf '%s\n' "$dir/.env"
        return
    fi

    if [ -f "$ENV_DIR/$name.env" ]; then
        printf '%s\n' "$ENV_DIR/$name.env"
        return
    fi

    if [ -f "$dir/.env" ]; then
        printf '%s\n' "$dir/.env"
        return
    fi

    printf '\n'
}

compose_exec() {

    type="$1"
    name="$2"
    shift 2

    config_load

    dir=$(registry_dir "$type" "$name")
    require_dir "$dir"

    compose=$(registry_compose "$dir")
    env=$(compose_env "$type" "$name" "$dir")

    if [ -n "$env" ]; then
        docker compose \
            --env-file "$env" \
            -f "$compose" \
            "$@"
    else
        docker compose \
            -f "$compose" \
            "$@"
    fi

}

compose_ps() {
    compose_exec "$1" "$2" ps -q
}

compose_up() {
    compose_exec "$1" "$2" up -d
}

compose_down() {
    compose_exec "$1" "$2" down
}

compose_logs() {
    compose_exec "$1" "$2" logs --tail=200
}

compose_pull() {
    compose_exec "$1" "$2" pull
}

compose_wait() {
    type="$1"
    name="$2"

    timeout="${COMPOSE_WAIT_TIMEOUT:-60}"
    elapsed=0

    while [ "$elapsed" -lt "$timeout" ]; do
        containers=$(compose_ps "$type" "$name" 2>/dev/null || true)

        if [ -z "$containers" ]; then
            sleep 1
            elapsed=$((elapsed + 1))
            continue
        fi

        pending=0

        for container in $containers; do
            health=$(docker inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{end}}' "$container" 2>/dev/null || true)
            running=$(docker inspect -f '{{.State.Running}}' "$container" 2>/dev/null || true)

            if [ -n "$health" ]; then
                [ "$health" = "healthy" ] || pending=1
            else
                [ "$running" = "true" ] || pending=1
            fi
        done

        if [ "$pending" -eq 0 ]; then
            info "Stack ready: $type/$name"
            return 0
        fi

        sleep 1
        elapsed=$((elapsed + 1))
    done

    die "Timeout waiting for stack: $type/$name"
}
