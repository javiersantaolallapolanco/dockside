#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/config.sh"
. "$DOCKSIDE_HOME/scripts/lib/compose.sh"

app_contract_file() {
  app="$1"
  printf '%s\n' "${APPS_DIR:-$DOCKER_ROOT/apps}/$app/app.env"
}

app_contract_load() {
  app="$1"
  dir="${APPS_DIR:-$DOCKER_ROOT/apps}/$app"

  NAME=
  DISPLAY_NAME=
  TYPE=
  HEALTHCHECK=
  REQUIRES=
  BACKUP_PATHS=

  require_file "$dir/app.env"
  . "$dir/app.env"
}

app_contract_validate() {
  app="$1"

  config_load

  dir="${APPS_DIR:-$DOCKER_ROOT/apps}/$app"
  require_dir "$dir"

  [ -f "$dir/compose.yml" ] || [ -f "$dir/docker-compose.yml" ] || die "App $app: missing compose.yml"
  require_file "$dir/.env"
  require_file "$dir/app.env"

  app_contract_load "$app"

  [ -n "$NAME" ] || die "App $app: NAME missing"
  [ "$NAME" = "$app" ] || die "App $app: NAME does not match directory"
  [ -n "$DISPLAY_NAME" ] || die "App $app: DISPLAY_NAME missing"
  [ -n "$TYPE" ] || die "App $app: TYPE missing"

  compose_file "$(compose_dir app "$app")" >/dev/null

  info "App contract OK: $app"
}

app_contract_healthcheck() {
  app="$1"

  config_load
  app_contract_load "$app"

  [ -n "$HEALTHCHECK" ] || return 0

  wait_http "$HEALTHCHECK" "app/$app"
}
