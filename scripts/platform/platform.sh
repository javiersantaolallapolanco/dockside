#!/bin/sh

. "$DOCKSIDE_HOME/scripts/compose/compose.sh"
. "$DOCKSIDE_HOME/scripts/core/state.sh"

PLATFORM_FILE="$DOCKSIDE_INSTALL_DIR/platform.conf"

platform_each_stack() {
  require_file "$PLATFORM_FILE"

  while IFS= read -r stack
  do
    [ -n "$stack" ] || continue
    case "$stack" in \#*) continue ;; esac
    printf '%s\n' "$stack"
  done < "$PLATFORM_FILE"
}


platform_wait() {
  stack="$1"

  compose_wait platform "$stack"
}

platform_start() {
  config_load

  for stack in $(platform_each_stack)
  do
    info "Starting stack: $stack"
    compose_up platform "$stack"
    platform_wait "$stack"
  done

  state_platform_up
  info "Platform is UP"
}

platform_stop() {
  config_load

  stacks="$(platform_each_stack)"

  for stack in $(printf "%s\n" "$stacks" | awk '{a[NR]=$0} END{for(i=NR;i>=1;i--)print a[i]}')
  do
    info "Stopping stack: $stack"
    compose_down platform "$stack"
  done

  state_platform_down
  info "Platform is DOWN"
}
