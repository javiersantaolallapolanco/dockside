#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/app.sh"
. "$DOCKSIDE_HOME/scripts/lib/compose.sh"

logs_show() {
  target="${1:-}"

  config_load
  state_load

  if [ -z "$target" ]; then
    target="${CURRENT_APP:-}"
  fi

  [ -n "$target" ] || die "Missing stack/app name and no current app configured"

  if [ -d "${APPS_DIR:-$DOCKER_ROOT/apps}/$target" ]; then
    app_compose "$target" logs --tail=200
    return 0
  fi

  if [ -d "$STACKS_DIR/$target" ]; then
    compose_cmd "$target" logs --tail=200
    return 0
  fi

  die "Unknown app or stack: $target"
}
