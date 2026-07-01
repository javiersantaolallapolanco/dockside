#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/compose.sh"
. "$DOCKSIDE_HOME/scripts/lib/state.sh"

logs_show() {
  target="${1:-}"

  config_load
  state_load

  if [ -z "$target" ]; then
    target="${CURRENT_APP:-}"
  fi

  [ -n "$target" ] || die "Missing app/stack name"

  if [ -d "${APPS_DIR:-$DOCKER_ROOT/apps}/$target" ]; then
    compose_exec app "$target" logs --tail=200
    return 0
  fi

  if [ -d "$STACKS_DIR/$target" ]; then
    compose_exec platform "$target" logs --tail=200
    return 0
  fi

  die "Unknown app or stack: $target"
}
