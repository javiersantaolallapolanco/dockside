#!/bin/sh
. "$DOCKSIDE_HOME/scripts/lib/compose.sh"
. "$DOCKSIDE_HOME/scripts/lib/state.sh"

app_stop_current() {
  state_load

  if [ -z "${CURRENT_APP:-}" ]; then
    info "No current app configured"
    return 0
  fi

  if [ ! -d "$STACKS_DIR/$CURRENT_APP" ]; then
    warn "Current app stack not found, skipping: $CURRENT_APP"
    CURRENT_APP_STATUS=DOWN
    state_save
    return 0
  fi

  compose_down "$CURRENT_APP"

  CURRENT_APP_STATUS=DOWN
  state_save
}
