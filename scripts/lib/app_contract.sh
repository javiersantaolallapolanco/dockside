#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/config.sh"
. "$DOCKSIDE_HOME/scripts/lib/compose.sh"
. "$DOCKSIDE_HOME/scripts/lib/registry.sh"

app_contract_load() {
  app="$1"
  dir=$(registry_dir app "$app")

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

  dir=$(registry_dir app "$app")
  require_dir "$dir"

  [ -f "$dir/compose.yml" ] || [ -f "$dir/docker-compose.yml" ] || die "App $app: missing compose.yml"
  require_file "$dir/.env"
  require_file "$dir/app.env"

  app_contract_load "$app"

  [ -n "$NAME" ] || die "App $app: NAME missing"
  [ "$NAME" = "$app" ] || die "App $app: NAME does not match directory"
  [ -n "$DISPLAY_NAME" ] || die "App $app: DISPLAY_NAME missing"
  [ -n "$TYPE" ] || die "App $app: TYPE missing"

  registry_compose "$dir" >/dev/null

  info "App contract OK: $app"
}

app_contract_healthcheck() {
  app="$1"

  config_load
  app_contract_load "$app"

  [ -n "$HEALTHCHECK" ] || return 0

  code=$(curl -s -o /dev/null -w '%{http_code}' "$HEALTHCHECK" || true)

  case "$code" in
    200|204|301|302|401|403)
      info "App health OK: $app ($code)"
      ;;
    *)
      warn "App health not ready: $app ($code)"
      ;;
  esac
}
