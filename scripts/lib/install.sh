#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/config.sh"

app_validate_repo() {
  repo="$1"

  require_dir "$repo"

  [ -f "$repo/docker-compose.yml" ] || \
  [ -f "$repo/compose.yml" ] || \
    die "Compose file not found"

  if [ ! -f "$repo/Dockerfile" ]; then
    warn "Dockerfile not found; assuming prebuilt image app"
  fi
}

app_install() {
  repo=$(cd "$1" && pwd)
  app=$(basename "$repo")

  config_load

  APPS_DIR="${APPS_DIR:-$DOCKER_ROOT/apps}"
  mkdir -p "$APPS_DIR"

  app_validate_repo "$repo"

  target="$APPS_DIR/$app"

  if [ -d "$target" ]; then
    die "Application already installed: $app"
  fi

  info "Installing $app"
  cp -R "$repo" "$target"

  rm -rf "$target/.git" "$target/.github"

  info "Installed in: $target"
}
