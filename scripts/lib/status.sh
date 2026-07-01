#!/bin/sh
. "$DOCKSIDE_HOME/scripts/lib/state.sh"

status_show() {
  state_load

  cat <<EOT
Dockside status

Platform:     $PLATFORM_STATUS
Current app:  ${CURRENT_APP:-}
App status:   $CURRENT_APP_STATUS
Last start:   $LAST_START
Last stop:    $LAST_STOP
EOT
}
