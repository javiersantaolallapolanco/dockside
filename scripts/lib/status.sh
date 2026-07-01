#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/state.sh"
. "$DOCKSIDE_HOME/scripts/lib/config.sh"
. "$DOCKSIDE_HOME/scripts/lib/apps_index.sh"
. "$DOCKSIDE_HOME/scripts/lib/platform.sh"

status_show() {
  state_load
  config_load

  echo
  echo "Dockside"
  echo "========="
  echo

  printf "Platform      : %s\n" "$PLATFORM_STATUS"
  printf "Current App   : %s\n" "${CURRENT_APP:-<none>}"
  printf "App Status    : %s\n" "$CURRENT_APP_STATUS"
  printf "Last Start    : %s\n" "$LAST_START"
  printf "Last Stop     : %s\n" "$LAST_STOP"

  echo
  echo "Platform stacks"
  echo "---------------"
  platform_each_stack

  echo
  echo "Installed applications"
  echo "----------------------"
  apps_index_list
}
