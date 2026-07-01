#!/bin/sh

. "$DOCKSIDE_HOME/scripts/platform/platform.sh"
. "$DOCKSIDE_HOME/scripts/application/index.sh"
. "$DOCKSIDE_HOME/scripts/application/contract.sh"
. "$DOCKSIDE_HOME/scripts/core/registry.sh"

doctor_ok() {
  printf '[OK] %s\n' "$*"
}

doctor_first_ghcr_image() {
  for file in "$DOCKER_ROOT"/apps/*/.env; do
    [ -f "$file" ] || continue
    image=$(grep '^GHCR_IMAGE=' "$file" | head -n 1 | cut -d '=' -f 2-)
    [ -n "$image" ] && printf '%s\n' "$image" && return 0
  done

  return 1
}

doctor_runner_ghcr() {
  RUNNER_CONTAINER="${RUNNER_CONTAINER:-dockside-runner}"

  docker ps --format '{{.Names}}' | grep -qx "$RUNNER_CONTAINER" || return 0

  docker exec "$RUNNER_CONTAINER" test -f /root/.docker/config.json || \
    die "$RUNNER_CONTAINER cannot access /root/.docker/config.json"

  docker exec "$RUNNER_CONTAINER" grep -q 'ghcr.io' /root/.docker/config.json || \
    die "$RUNNER_CONTAINER docker config does not contain ghcr.io credentials"

  doctor_ok "$RUNNER_CONTAINER docker credentials"

  image=$(doctor_first_ghcr_image || true)

  if [ -n "$image" ]; then
    docker exec "$RUNNER_CONTAINER" docker pull "$image" >/dev/null || \
      die "$RUNNER_CONTAINER cannot pull $image"

    doctor_ok "$RUNNER_CONTAINER GHCR pull"
  fi
}

doctor_stack() {
  type="$1"
  name="$2"

  dir=$(registry_dir "$type" "$name")
  require_dir "$dir"
  registry_compose "$dir" >/dev/null

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

  doctor_runner_ghcr

  for app in $(apps_index_list); do
    app_contract_validate "$app"
  done

  state_load

  if [ "${CURRENT_APP_STATUS:-DOWN}" = "UP" ] && [ -n "${CURRENT_APP:-}" ]; then
    app_contract_healthcheck "$CURRENT_APP"
  fi

  doctor_ok "STATE_FILE=$STATE_FILE"
  doctor_ok "Dockside doctor completed"
}
