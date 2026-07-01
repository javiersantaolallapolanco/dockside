#!/bin/sh
. "$DOCKSIDE_HOME/scripts/lib/compose.sh"
. "$DOCKSIDE_HOME/scripts/lib/state.sh"
. "$DOCKSIDE_HOME/scripts/lib/app.sh"

platform_start() {
  config_load

  compose_up "$TRAEFIK_STACK"
  compose_wait "$TRAEFIK_STACK"
  wait_http "${TRAEFIK_HEALTH_URL:-}" "$TRAEFIK_STACK"

  compose_up "$SUPABASE_STACK"
  compose_wait "$SUPABASE_STACK"
  wait_http "${SUPABASE_HEALTH_URL:-}" "$SUPABASE_STACK"

  compose_up "$RUNNER_STACK"
  compose_wait "$RUNNER_STACK"
  wait_http "${RUNNER_HEALTH_URL:-}" "$RUNNER_STACK"

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
