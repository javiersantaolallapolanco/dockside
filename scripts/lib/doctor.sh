#!/bin/sh
. "$DOCKSIDE_HOME/scripts/lib/app.sh"

doctor_ok() {
  printf '[OK] %s\n' "$*"
}

doctor_check_command() {
  command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"
  doctor_ok "Command: $1"
}

doctor_check_stack() {
  stack="$1"

  require_dir "$STACKS_DIR/$stack"
  compose_file_for_stack "$stack" >/dev/null

  env_file=$(compose_env_for_stack "$stack")

  doctor_ok "Stack: $stack"

  if [ -n "$env_file" ]; then
    doctor_ok "Env: $env_file"
  else
    warn "No env file for stack: $stack"
  fi
}

doctor_run() {
  config_load

  doctor_check_command docker

  docker compose version >/dev/null 2>&1 || die "docker compose is not available"
  doctor_ok "Docker Compose"

  require_dir "$DOCKER_ROOT"
  require_dir "$STACKS_DIR"
  require_dir "$ENV_DIR"
  doctor_ok "Docker root: $DOCKER_ROOT"
  doctor_ok "Stacks dir: $STACKS_DIR"
  doctor_ok "Env dir: $ENV_DIR"

  doctor_check_stack "$TRAEFIK_STACK"
  doctor_check_stack "$SUPABASE_STACK"
  doctor_check_stack "$RUNNER_STACK"

  state_load

  if [ -n "${CURRENT_APP:-}" ]; then
    doctor_check_stack "$CURRENT_APP"
  fi

  doctor_ok "State file: $STATE_FILE"
  doctor_ok "Dockside installation is valid"
}
