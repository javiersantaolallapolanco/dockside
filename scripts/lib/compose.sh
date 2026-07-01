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

  if [ -f "$ENV_DIR/$stack.env" ]; then
    printf '%s\n' "$ENV_DIR/$stack.env"
    return 0
  fi

  base=$(printf '%s\n' "$stack" | sed 's/[0-9].*$//')
  if [ -n "$base" ] && [ -f "$ENV_DIR/$base.env" ]; then
    printf '%s\n' "$ENV_DIR/$base.env"
    return 0
  fi

  if [ -f "$STACKS_DIR/$stack/.env" ]; then
    printf '%s\n' "$STACKS_DIR/$stack/.env"
    return 0
  fi

  printf '%s\n' ""
}

compose_up() {
  stack="$1"
  config_load
  require_command docker
  require_dir "$STACKS_DIR/$stack"

  compose_file=$(compose_file_for_stack "$stack")
  env_file=$(compose_env_for_stack "$stack")

  info "Starting stack: $stack"

  if [ -n "$env_file" ]; then
    docker compose --env-file "$env_file" -f "$compose_file" up -d
  else
    docker compose -f "$compose_file" up -d
  fi
}

compose_down() {
  stack="$1"
  config_load
  require_command docker

  if [ ! -d "$STACKS_DIR/$stack" ]; then
    warn "Stack directory not found, skipping: $stack"
    return 0
  fi

  compose_file=$(compose_file_for_stack "$stack")
  env_file=$(compose_env_for_stack "$stack")

  info "Stopping stack: $stack"

  if [ -n "$env_file" ]; then
    docker compose --env-file "$env_file" -f "$compose_file" down
  else
    docker compose -f "$compose_file" down
  fi
}
