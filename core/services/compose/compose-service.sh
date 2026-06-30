#!/bin/sh

compose_service_load_stack() {
    stack="$1"
    conf="$DOCKSIDE_ROOT/config/stacks/$stack.conf"

    if [ ! -f "$conf" ]; then
        runtime_log_error "Stack config not found: $stack"
        return 1
    fi

    COMPOSE_FILE=""
    ENV_FILE=""

    . "$conf"

    if [ -z "$COMPOSE_FILE" ]; then
        runtime_log_error "COMPOSE_FILE missing for stack: $stack"
        return 1
    fi

    COMPOSE_FILE="$DOCKSIDE_ROOT/$COMPOSE_FILE"

    if [ -n "${ENV_FILE:-}" ]; then
        ENV_FILE="$DOCKSIDE_ROOT/$ENV_FILE"
    fi

    export COMPOSE_FILE
    export ENV_FILE
}

compose_service_run_stack() {
    stack="$1"
    shift

    runtime_load log
    runtime_load compose

    compose_service_load_stack "$stack"

    runtime_log_info "docker compose $stack: $*"
    runtime_compose_run "$ENV_FILE" "$COMPOSE_FILE" "$@"
}
