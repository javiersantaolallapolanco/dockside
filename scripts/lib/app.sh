#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/compose.sh"
. "$DOCKSIDE_HOME/scripts/lib/state.sh"

app_stop_current() {
  state_load

  [ -n "${CURRENT_APP:-}" ] || return 0

  info "Stopping app: $CURRENT_APP"
  compose_exec app "$CURRENT_APP" down || true

  CURRENT_APP_STATUS=DOWN
  state_save
}

app_use() {
  app="$1"

  [ -n "$app" ] || die "Usage: dockside use <app>"

  state_load

  [ "${PLATFORM_STATUS:-DOWN}" = "UP" ] || die "Platform is not UP. Run: dockside start"

  app_stop_current

  info "Starting app: $app"
  compose_exec app "$app" up -d

  state_load
  CURRENT_APP="$app"
  CURRENT_APP_STATUS=UP
  state_save

  info "Current app is now: $app"
}
