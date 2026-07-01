#!/bin/sh

. "$DOCKSIDE_HOME/scripts/application/app.sh"
. "$DOCKSIDE_HOME/scripts/application/index.sh"

app_remove() {
  app="$1"
  delete_data="${2:-}"

  [ -n "$app" ] || die "Usage: dockside remove <app> [--delete-data]"

  config_load
  state_load

  dir="${APPS_DIR:-$DOCKER_ROOT/apps}/$app"

  [ -d "$dir" ] || die "Application not installed: $app"

  if [ "${CURRENT_APP:-}" = "$app" ]; then
    info "Stopping active app before remove: $app"
    app_stop_current
    CURRENT_APP=
    CURRENT_APP_STATUS=DOWN
    state_save
  else
    compose_exec app "$app" down || true
  fi

  if [ "$delete_data" = "--delete-data" ]; then
    info "Removing app directory: $dir"
    rm -rf "$dir"
  else
    info "Keeping app directory, disabling app: $dir"
    mv "$dir" "$dir.removed.$(date '+%Y%m%d%H%M%S')"
  fi

  apps_index_remove "$app"

  info "Removed app: $app"
}
