#!/bin/sh

compose_service_load_stack() {
    stack="$1"

    runtime_load log

    . "$DOCKSIDE_ROOT/core/services/catalog-service.sh"

    conf="$(catalog_config_file "$stack")"

    if [ ! -f "$conf" ]; then
        runtime_log_error "Stack config not found: $stack"
        return 1
    fi

    STACK_NAME=""
    COMPOSE_FILE=""
    ENV_FILE=""

    . "$conf"

    if [ -z "$STACK_NAME" ]; then
        STACK_NAME="$stack"
    fi

    if [ -z "$COMPOSE_FILE" ]; then
        runtime_log_error "COMPOSE_FILE not defined for stack: $stack"
        return 1
    fi

    COMPOSE_FILE="$DOCKSIDE_ROOT/$COMPOSE_FILE"

    if [ -n "${ENV_FILE:-}" ]; then
        ENV_FILE="$DOCKSIDE_ROOT/$ENV_FILE"
    fi

    if [ ! -f "$COMPOSE_FILE" ]; then
        runtime_log_error "Compose file not found for stack $stack: $COMPOSE_FILE"
        return 1
    fi

    export STACK_NAME
    export COMPOSE_FILE
    export ENV_FILE
}

compose_service_stack_compose_file() {
    stack="$1"
    compose_service_load_stack "$stack"
    printf '%s\n' "$COMPOSE_FILE"
}

compose_service_stack_env_file() {
    stack="$1"
    compose_service_load_stack "$stack"
    printf '%s\n' "$ENV_FILE"
}

compose_service_run_stack() {
    stack="$1"
    shift

    runtime_load log
    runtime_load compose

    compose_service_load_stack "$stack"

    runtime_log_info "compose $stack: $*"
    runtime_compose_run "$ENV_FILE" "$COMPOSE_FILE" "$@"
}
