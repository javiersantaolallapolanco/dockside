#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/compose.sh"
. "$DOCKSIDE_HOME/scripts/lib/state.sh"

app_dir() {
    config_load
    printf '%s\n' "${APPS_DIR:-$DOCKER_ROOT/apps}/$1"
}

app_compose_file() {

    app="$1"
    dir=$(app_dir "$app")

    if [ -f "$dir/compose.yml" ]; then
        printf '%s\n' "$dir/compose.yml"
        return
    fi

    if [ -f "$dir/docker-compose.yml" ]; then
        printf '%s\n' "$dir/docker-compose.yml"
        return
    fi

    die "Compose not found for app: $app"
}

app_env_file() {

    app="$1"

    eval "alias=\${ENV_ALIAS_$app:-}"

    if [ -n "$alias" ] && [ -f "$ENV_DIR/$alias.env" ]; then
        printf '%s\n' "$ENV_DIR/$alias.env"
        return
    fi

    if [ -f "$ENV_DIR/$app.env" ]; then
        printf '%s\n' "$ENV_DIR/$app.env"
        return
    fi

    printf '%s\n' ""
}

app_compose() {

    app="$1"
    shift

    compose=$(app_compose_file "$app")
    env=$(app_env_file "$app")

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

app_stop_current() {

    state_load

    [ -n "${CURRENT_APP:-}" ] || return 0

    info "Stopping app: $CURRENT_APP"

    app_compose "$CURRENT_APP" down || true

    CURRENT_APP_STATUS=DOWN

    state_save

}

app_use() {

    app="$1"

    state_load

    app_stop_current

    info "Starting app: $app"

    app_compose "$app" up -d

    CURRENT_APP="$app"
    CURRENT_APP_STATUS=UP

    state_save

}
