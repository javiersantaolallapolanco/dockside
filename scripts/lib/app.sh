#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/common.sh"
. "$DOCKSIDE_HOME/scripts/lib/config.sh"
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
    return 0
  fi

  if [ -f "$dir/docker-compose.yml" ]; then
    printf '%s\n' "$dir/docker-compose.yml"
    return 0
  fi

  die "Compose not found for app: $app"
}

app_env_file() {
  app="$1"
  dir=$(app_dir "$app")

  if [ -f "$dir/.env" ]; then
    printf '%s\n' "$dir/.env"
    return 0
  fi

  printf '%s\n' ""
}

app_compose() {
  app="$1"
  shift

  config_load
  require_command docker

  compose=$(app_compose_file "$app")
  env=$(app_env_file "$app")

  if [ -n "$env" ]; then
    docker compose --env-file "$env" -f "$compose" "$@"
  else
    docker compose -f "$compose" "$@"
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

  [ -n "$app" ] || die "Usage: dockside use <app>"

  state_load

  if [ "${PLATFORM_STATUS:-DOWN}" != "UP" ]; then
    die "Platform is not UP. Run: dockside start"
  fi

  app_stop_current

  info "Starting app: $app"
  app_compose "$app" up -d

  state_load
  CURRENT_APP="$app"
  CURRENT_APP_STATUS=UP
  state_save

  info "Current app is now: $app"
}
