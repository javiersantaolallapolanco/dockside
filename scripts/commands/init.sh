#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/lib/config.sh"
. "$DOCKSIDE_HOME/scripts/lib/state.sh"

require_command docker

DOCKER_ROOT="${DOCKER_ROOT:-/share/CACHEDEV1_DATA/docker}"

mkdir -p \
    "$DOCKER_ROOT/apps" \
    "$DOCKER_ROOT/backups" \
    "$DOCKER_ROOT/platform/stacks" \
    "$DOCKSIDE_INSTALL_DIR" \
    "$DOCKSIDE_INSTALL_DIR/logs"

config_init
state_init

PLATFORM_FILE="$DOCKSIDE_INSTALL_DIR/platform.conf"

if [ ! -f "$PLATFORM_FILE" ]; then
cat > "$PLATFORM_FILE" <<EOT
traefik
supabase
github-runner
EOT
fi

info "Dockside initialized"
info "Installation : $DOCKSIDE_INSTALL_DIR"
info "Docker root  : $DOCKER_ROOT"
