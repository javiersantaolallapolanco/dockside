#!/bin/sh
. "$DOCKSIDE_HOME/scripts/lib/common.sh"

DOCKSIDE_INSTALL_DIR="${DOCKSIDE_INSTALL_DIR:-/share/CACHEDEV1_DATA/docker/dockside}"
DOCKSIDE_CONFIG_FILE="$DOCKSIDE_INSTALL_DIR/dockside.env"

config_init() {
  mkdir -p "$DOCKSIDE_INSTALL_DIR" "$DOCKSIDE_INSTALL_DIR/logs" "$DOCKSIDE_INSTALL_DIR/backups"

  if [ ! -f "$DOCKSIDE_CONFIG_FILE" ]; then
    cat > "$DOCKSIDE_CONFIG_FILE" <<'EOT'
DOCKER_ROOT=/share/CACHEDEV1_DATA/docker
STACKS_DIR=${DOCKER_ROOT}/stacks
ENV_DIR=${DOCKER_ROOT}/env
APPS_DIR=${DOCKER_ROOT}/apps
BACKUPS_DIR=${DOCKER_ROOT}/backups

WAIT_TIMEOUT=180
WAIT_INTERVAL=5
EOT
  fi
}

config_load() {
  require_file "$DOCKSIDE_CONFIG_FILE"
  . "$DOCKSIDE_CONFIG_FILE"

  WAIT_TIMEOUT="${WAIT_TIMEOUT:-180}"
  WAIT_INTERVAL="${WAIT_INTERVAL:-5}"
  APPS_DIR="${APPS_DIR:-$DOCKER_ROOT/apps}"
  BACKUPS_DIR="${BACKUPS_DIR:-$DOCKER_ROOT/backups}"

  require_dir "$DOCKER_ROOT"
  require_dir "$STACKS_DIR"
  require_dir "$ENV_DIR"
  require_dir "$APPS_DIR"
}
