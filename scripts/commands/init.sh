#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/lib/config.sh"
. "$DOCKSIDE_HOME/scripts/lib/state.sh"

require_command docker

config_init
config_load

mkdir -p \
    "$DOCKER_ROOT/apps" \
    "$DOCKER_ROOT/backups" \
    "$DOCKER_ROOT/platform/stacks"

state_init

PLATFORM_FILE="$DOCKSIDE_INSTALL_DIR/platform.conf"

if [ ! -f "$PLATFORM_FILE" ]; then
    cp "$DOCKSIDE_HOME/templates/platform.conf" \
       "$PLATFORM_FILE"
fi

info "Dockside initialized"
