#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/platform.sh"
. "$DOCKSIDE_HOME/scripts/lib/apps_index.sh"

update_target() {
  type="$1"
  name="$2"

  info "Updating $type: $name"
  compose_exec "$type" "$name" pull
  compose_exec "$type" "$name" up -d

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

      if [ -d "$STACKS_DIR/$target" ]; then
        update_target platform "$target"
        return 0
      fi

      die "Unknown update target: $target"
      ;;
  esac
}
