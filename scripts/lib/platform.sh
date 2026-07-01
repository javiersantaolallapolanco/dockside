#!/bin/sh
. "$DOCKSIDE_HOME/scripts/lib/compose.sh"
. "$DOCKSIDE_HOME/scripts/lib/state.sh"
. "$DOCKSIDE_HOME/scripts/lib/app.sh"

platform_start() {
  config_load

  compose_up "$TRAEFIK_STACK"
  compose_up "$SUPABASE_STACK"
  compose_up "$RUNNER_STACK"

  state_platform_up
  info "Platform is UP"
}

platform_stop() {
  config_load

  app_stop_current

  compose_down "$RUNNER_STACK"
  compose_down "$SUPABASE_STACK"
  compose_down "$TRAEFIK_STACK"

  state_platform_down
  info "Platform is DOWN"
}
