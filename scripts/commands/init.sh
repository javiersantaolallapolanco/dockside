#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/lib/state.sh"

require_command docker

config_init
state_init
config_load

info "Dockside initialized"
info "Config: $DOCKSIDE_CONFIG_FILE"
info "State:  $STATE_FILE"
