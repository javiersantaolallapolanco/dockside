#!/bin/sh
. "$DOCKSIDE_HOME/scripts/lib/config.sh"

compose_file_for_stack() {
  stack_dir="$STACKS_DIR/$1"

  if [ -f "$stack_dir/compose.yml" ]; then
    printf '%s\n' "$stack_dir/compose.yml"
    return 0
  fi

  if [ -f "$stack_dir/docker-compose.yml" ]; then
    printf '%s\n' "$stack_dir/docker-compose.yml"
    return 0
  fi

  die "No compose file found for stack: $1"
}

compose_env_for_stack() {
  stack="$1"
  eval "alias_name=\${ENV_ALIAS_$stack:-}"

  if [ -n "$alias_name" ] && [ -f "$ENV_DIR/$alias_name.env" ]; then
    printf '%s\n' "$ENV_DIR/$alias_name.env"
    return 0
  fi

  if [ -f "$ENV_DIR/$stack.env" ]; then
    printf '%s\n' "$ENV_DIR/$stack.env"
    return 0
  fi

  if [ -f "$STACKS_DIR/$stack/.env" ]; then
    printf '%s\n' "$STACKS_DIR/$stack/.env"
    return 0
  fi

  printf '%s\n' ""
}

compose_cmd() {
  stack="$1"
  shift

  compose_file=$(compose_file_for_stack "$stack")
  env_file=$(compose_env_for_stack "$stack")

  if [ -n "$env_file" ]; then
    docker compose --env-file "$env_file" -f "$compose_file" "$@"
  else
    docker compose -f "$compose_file" "$@"
  fi
}

compose_container_ids() {
  stack="$1"
  compose_cmd "$stack" ps -q
}

compose_up() {
  stack="$1"
  config_load
  require_command docker
  require_dir "$STACKS_DIR/$stack"

  info "Starting stack: $stack"
  compose_cmd "$stack" up -d
}

compose_down() {
  stack="$1"
  config_load
  require_command docker

  if [ ! -d "$STACKS_DIR/$stack" ]; then
    warn "Stack directory not found, skipping: $stack"
    return 0
  fi

  info "Stopping stack: $stack"
  compose_cmd "$stack" down
}

container_running() {
  docker inspect -f '{{.State.Running}}' "$1" 2>/dev/null
}

container_health() {
  docker inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' "$1" 2>/dev/null
}

compose_wait() {
  stack="$1"
  config_load

  elapsed=0

  while [ "$elapsed" -le "$WAIT_TIMEOUT" ]; do
    ids=$(compose_container_ids "$stack" || true)

    if [ -n "$ids" ]; then
      all_ok=1

      for id in $ids; do
        running=$(container_running "$id")
        health=$(container_health "$id")

        if [ "$running" != "true" ]; then
          all_ok=0
        fi

        if [ "$health" = "starting" ] || [ "$health" = "unhealthy" ]; then
          all_ok=0
        fi
      done

      if [ "$all_ok" = "1" ]; then
        info "Stack ready: $stack"
        return 0
      fi
    fi

    sleep "$WAIT_INTERVAL"
    elapsed=$((elapsed + WAIT_INTERVAL))
  done

  warn "Timeout waiting for full health: $stack"
  warn "Continuing because containers may have no healthcheck"
  return 0
}

wait_http() {
  url="$1"
  label="$2"

  [ -n "$url" ] || return 0
  require_command curl

  elapsed=0

  while [ "$elapsed" -le "$WAIT_TIMEOUT" ]; do
    code=$(curl -s -o /dev/null -w '%{http_code}' "$url" || true)

    case "$code" in
      200|204|301|302|401|403)
        info "HTTP ready: $label ($code)"
        return 0
        ;;
    esac

    sleep "$WAIT_INTERVAL"
    elapsed=$((elapsed + WAIT_INTERVAL))
  done

  warn "Timeout waiting for HTTP: $label $url"
  return 0
}
