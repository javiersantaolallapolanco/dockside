#!/bin/sh
. "$DOCKSIDE_HOME/scripts/lib/app.sh"

logs_show() {
  target="${1:-}"

  config_load
  state_load

  if [ -z "$target" ]; then
    target="${CURRENT_APP:-}"
  fi

  [ -n "$target" ] || die "Missing stack name and no current app configured"

  require_dir "$STACKS_DIR/$target"

  compose_file=$(compose_file_for_stack "$target")
  env_file=$(compose_env_for_stack "$target")

  if [ -n "$env_file" ]; then
    docker compose --env-file "$env_file" -f "$compose_file" logs --tail=200
  else
    docker compose -f "$compose_file" logs --tail=200
  fi
}
