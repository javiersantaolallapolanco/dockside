#!/bin/sh

app_fail() {
    runtime_load log
    runtime_log_fatal "$1"
}

app_root() {
    if [ -n "${DOCKSIDE_APPS_DIR:-}" ]; then
        printf '%s\n' "$DOCKSIDE_APPS_DIR"
    else
        printf '%s\n' "$DOCKSIDE_ROOT/apps"
    fi
}

app_validate_name() {
    name="$1"

    [ -n "$name" ] || return 1

    case "$name" in
        *[!abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-]*)
            return 1
            ;;
    esac

    return 0
}

app_dir() {
    name="$1"
    printf '%s\n' "$(app_root)/$name"
}

app_compose_file() {
    name="$1"
    printf '%s\n' "$(app_dir "$name")/docker-compose.yml"
}

app_env_file() {
    name="$1"
    printf '%s\n' "$(app_dir "$name")/.env"
}

app_config_file() {
    name="$1"
    printf '%s\n' "$(app_dir "$name")/app.conf"
}

app_exists() {
    name="$1"
    [ -d "$(app_dir "$name")" ]
}

app_create_dirs() {
    name="$1"

    mkdir -p "$(app_dir "$name")"
    mkdir -p "$(app_dir "$name")/data"
}

app_write_env_if_missing() {
    name="$1"
    image="$2"
    port="$3"

    env_file="$(app_env_file "$name")"

    if [ -f "$env_file" ]; then
        cp "$env_file" "$env_file.bak.$(date +%Y%m%d%H%M%S)"
        return 0
    fi

    cat > "$env_file" <<EOF_ENV
APP_NAME=$name
APP_IMAGE=$image
APP_PORT=$port
EOF_ENV
}

app_write_config() {
    name="$1"
    image="$2"
    port="$3"

    conf="$(app_config_file "$name")"

    if [ -f "$conf" ]; then
        cp "$conf" "$conf.bak.$(date +%Y%m%d%H%M%S)"
    fi

    cat > "$conf" <<EOF_CONF
APP_NAME=$name
APP_IMAGE=$image
APP_PORT=$port
COMPOSE_FILE=$(app_compose_file "$name")
ENV_FILE=$(app_env_file "$name")
EOF_CONF
}

app_write_compose_if_missing() {
    name="$1"

    compose_file="$(app_compose_file "$name")"

    if [ -f "$compose_file" ]; then
        cp "$compose_file" "$compose_file.bak.$(date +%Y%m%d%H%M%S)"
        return 0
    fi

    cat > "$compose_file" <<'EOF_COMPOSE'
services:
  app:
    image: ${APP_IMAGE}
    container_name: ${APP_NAME}
    restart: unless-stopped
    env_file:
      - .env
    ports:
      - "${APP_PORT}:3000"
EOF_COMPOSE
}

app_create() {
    name="$1"
    image="$2"
    port="$3"
    force="$4"

    runtime_load log

    app_validate_name "$name" || app_fail "Invalid app name: $name"

    if app_exists "$name" && [ "$force" != "yes" ]; then
        app_fail "App already exists: $name"
    fi

    app_create_dirs "$name"
    app_write_env_if_missing "$name" "$image" "$port"
    app_write_config "$name" "$image" "$port"
    app_write_compose_if_missing "$name"

    runtime_log_info "App created: $name"
    printf '%s\n' "$(app_dir "$name")"
}

app_load() {
    name="$1"

    app_validate_name "$name" || app_fail "Invalid app name: $name"

    conf="$(app_config_file "$name")"
    [ -f "$conf" ] || app_fail "App config not found: $conf"

    APP_NAME=""
    APP_IMAGE=""
    APP_PORT=""
    COMPOSE_FILE=""
    ENV_FILE=""

    . "$conf"

    [ -n "$APP_NAME" ] || APP_NAME="$name"
    [ -n "$COMPOSE_FILE" ] || COMPOSE_FILE="$(app_compose_file "$name")"
    [ -n "$ENV_FILE" ] || ENV_FILE="$(app_env_file "$name")"

    [ -f "$COMPOSE_FILE" ] || app_fail "App compose file not found: $COMPOSE_FILE"
    [ -f "$ENV_FILE" ] || app_fail "App env file not found: $ENV_FILE"

    export APP_NAME APP_IMAGE APP_PORT COMPOSE_FILE ENV_FILE
}

app_list() {
    root="$(app_root)"

    [ -d "$root" ] || return 0

    find "$root" -mindepth 1 -maxdepth 1 -type d 2>/dev/null \
        | sed 's#^.*/##' \
        | sort
}

app_compose_run() {
    name="$1"
    shift

    runtime_load compose

    app_load "$name"

    runtime_compose_run "$ENV_FILE" "$COMPOSE_FILE" "$@"
}

app_status() {
    name="$1"

    app_load "$name"

    printf "%-18s %s\n" "App" "$APP_NAME"
    printf "%-18s %s\n" "Image" "${APP_IMAGE:-}"
    printf "%-18s %s\n" "Port" "${APP_PORT:-}"
    printf "%-18s %s\n" "Compose" "$COMPOSE_FILE"
    printf "%-18s %s\n" "Env" "$ENV_FILE"
    printf "\n"

    app_compose_run "$name" ps
}

app_deploy() {
    name="$1"
    pull="$2"
    build="$3"

    runtime_load log

    app_load "$name"

    runtime_log_info "Validating app: $name"
    app_compose_run "$name" config >/dev/null

    if [ "$pull" = "yes" ]; then
        if ! app_compose_run "$name" pull; then
            runtime_log_warn "Pull failed or skipped by Compose for app: $name"
        fi
    fi

    if [ "$build" = "yes" ]; then
        if ! app_compose_run "$name" build; then
            runtime_log_warn "Build failed or not required for app: $name"
        fi
    fi

    runtime_log_info "Starting app: $name"
    app_compose_run "$name" up -d
}
