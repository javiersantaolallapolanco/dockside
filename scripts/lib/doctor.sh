#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/platform.sh"

doctor_ok() {
  printf '[OK] %s\n' "$*"
}

doctor_stack() {
  type="$1"
  name="$2"

  dir=$(compose_dir "$type" "$name")
  require_dir "$dir"
  compose_file "$dir" >/dev/null

  doctor_ok "$type/$name"
}

doctor_run() {
  config_load

  require_command docker
  docker compose version >/dev/null 2>&1 || die "docker compose unavailable"

  doctor_ok "docker"
  doctor_ok "docker compose"

  require_dir "$DOCKER_ROOT"
  require_dir "$STACKS_DIR"
  require_dir "$ENV_DIR"

  doctor_ok "DOCKER_ROOT=$DOCKER_ROOT"
  doctor_ok "STACKS_DIR=$STACKS_DIR"
  doctor_ok "ENV_DIR=$ENV_DIR"

  require_file "$PLATFORM_FILE"
  doctor_ok "PLATFORM_FILE=$PLATFORM_FILE"

  for stack in $(platform_each_stack); do
    doctor_stack platform "$stack"
  done

  state_load

  if [ -n "${CURRENT_APP:-}" ]; then
    doctor_stack app "$CURRENT_APP"
  fi

  doctor_ok "STATE_FILE=$STATE_FILE"
}
