#!/bin/sh

. "$DOCKSIDE_HOME/scripts/core/config.sh"

apps_index_file() {
  config_load
  printf '%s\n' "${APPS_DIR:-$DOCKER_ROOT/apps}/index"
}

apps_index_init() {
  file=$(apps_index_file)
  dir=$(dirname "$file")
  mkdir -p "$dir"
  [ -f "$file" ] || : > "$file"
}

apps_index_has() {
  app="$1"
  file=$(apps_index_file)
  [ -f "$file" ] || return 1
  grep -x "$app" "$file" >/dev/null 2>&1
}

apps_index_add() {
  app="$1"
  apps_index_init

  if ! apps_index_has "$app"; then
    printf '%s\n' "$app" >> "$(apps_index_file)"
  fi
}

apps_index_remove() {
  app="$1"
  apps_index_init

  file=$(apps_index_file)
  tmp="$file.tmp.$$"

  grep -v -x "$app" "$file" > "$tmp" || true
  mv "$tmp" "$file"
}

apps_index_list() {
  apps_index_init
  cat "$(apps_index_file)"
}
