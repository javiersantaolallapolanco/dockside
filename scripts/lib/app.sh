#!/bin/sh
. "$DOCKSIDE_HOME/scripts/lib/compose.sh"
. "$DOCKSIDE_HOME/scripts/lib/state.sh"

app_require() {
  app="$1"

  [ -n "$app" ] || die "Missing app name"
  require_dir "$STACKS_DIR/$app"
  compose_file_for_stack "$app" >/dev/null
}

app_stop_current() {
  state_load

  if [ -z "${CURRENT_APP:-}" ]; then
    info "No current app configured"
    return 0
  fi

  if [ ! -d "$STACKS_DIR/$CURRENT_APP" ]; then
    warn "Current app stack not found, skipping: $CURRENT_APP"
    CURRENT_APP_STATUS=DOWN
    state_save
    return 0
  fi

  compose_down "$CURRENT_APP"

  CURRENT_APP_STATUS=DOWN
  state_save
}

app_use() {
  app="$1"

  config_load
  app_require "$app"
  state_load

  if [ "${PLATFORM_STATUS:-DOWN}" != "UP" ]; then
    die "Platform is not UP. Run: dockside start"
  fi

  if [ "${CURRENT_APP:-}" = "$app" ] && [ "${CURRENT_APP_STATUS:-DOWN}" = "UP" ]; then
    info "App already active: $app"
    return 0
  fi

  app_stop_current

  compose_up "$app"

  state_load
  CURRENT_APP="$app"
  CURRENT_APP_STATUS=UP
  state_save

  info "Current app is now: $app"
}
