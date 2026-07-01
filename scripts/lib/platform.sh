#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/compose.sh"
. "$DOCKSIDE_HOME/scripts/lib/state.sh"
. "$DOCKSIDE_HOME/scripts/lib/app.sh"

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

platform_key() {
  printf '%s\n' "$1" | sed 's/-/_/g'
}

platform_wait() {
  stack="$1"
  key=$(platform_key "$stack")

  eval "mode=\${WAIT_MODE_$key:-compose}"
  eval "url=\${HEALTH_URL_$key:-}"

  case "$mode" in
    none)
      info "Skipping wait: $stack"
      ;;
    http)
      wait_http "$url" "$stack"
      ;;
    compose|*)
      compose_wait platform "$stack"
      ;;
  esac
}

platform_start() {
  config_load

  for stack in $(platform_each_stack)
  do
    info "Starting stack: $stack"
    compose_exec platform "$stack" up -d
    platform_wait "$stack"
  done

  state_platform_up
  info "Platform is UP"
}

platform_stop() {
  config_load

  app_stop_current

  stacks="$(platform_each_stack)"

  for stack in $(printf "%s\n" "$stacks" | awk '{a[NR]=$0} END{for(i=NR;i>=1;i--)print a[i]}')
  do
    info "Stopping stack: $stack"
    compose_exec platform "$stack" down
  done

  state_platform_down
  info "Platform is DOWN"
}
