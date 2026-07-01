#!/bin/sh

. "$DOCKSIDE_HOME/scripts/compose/compose.sh"
. "$DOCKSIDE_HOME/scripts/application/index.sh"
. "$DOCKSIDE_HOME/scripts/platform/platform.sh"

update_target() {
  type="$1"
  name="$2"

  info "Updating $type: $name"
  compose_pull "$type" "$name"
  compose_up "$type" "$name"

  if [ "$type" = "platform" ]; then
    platform_wait "$name"
  fi
}

update_all() {
  config_load

  for stack in $(platform_each_stack); do
    update_target platform "$stack"
  done

  for app in $(apps_index_list); do
    update_target app "$app"
  done

  info "Update complete"
}

update_run() {
  config_load
  target="${1:-all}"

  case "$target" in
    all)
      update_all
      ;;
    platform)
      for stack in $(platform_each_stack); do
        update_target platform "$stack"
      done
      ;;
    apps)
      for app in $(apps_index_list); do
        update_target app "$app"
      done
      ;;
    *)
      if apps_index_has "$target"; then
        update_target app "$target"
        return 0
      fi

      if registry_exists platform "$target"; then
        update_target platform "$target"
        return 0
      fi

      die "Unknown update target: $target"
      ;;
  esac
}
