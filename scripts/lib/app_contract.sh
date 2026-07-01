#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/config.sh"
. "$DOCKSIDE_HOME/scripts/lib/compose.sh"

app_contract_file() {
  app="$1"
  printf '%s\n' "${APPS_DIR:-$DOCKER_ROOT/apps}/$app/app.env"
}

app_contract_validate() {
  app="$1"

  config_load

  dir="${APPS_DIR:-$DOCKER_ROOT/apps}/$app"
  require_dir "$dir"

  [ -f "$dir/compose.yml" ] || [ -f "$dir/docker-compose.yml" ] || die "App $app: missing compose.yml"
  require_file "$dir/.env"
  require_file "$dir/app.env"

  NAME=
  DISPLAY_NAME=
  TYPE=
  HEALTHCHECK=
  REQUIRES=
  BACKUP_PATHS=

  . "$dir/app.env"

  [ -n "$NAME" ] || die "App $app: NAME missing in app.env"
  [ "$NAME" = "$app" ] || die "App $app: NAME does not match directory"
  [ -n "$DISPLAY_NAME" ] || die "App $app: DISPLAY_NAME missing in app.env"
  [ -n "$TYPE" ] || die "App $app: TYPE missing in app.env"

  compose_file "$(compose_dir app "$app")" >/dev/null

  info "App contract OK: $app"
}
