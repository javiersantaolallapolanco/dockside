#!/bin/sh
set -eu

BASE_DIR="/share/CACHEDEV1_DATA/docker"
REPO_DIR="$BASE_DIR/git/mundial2026-infra"
RUNTIME_DIR="$BASE_DIR/stacks"
ENV_DIR="$BASE_DIR/env"

log() {
  echo "==> $*"
}

warn() {
  echo "WARN: $*" >&2
}

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

require_file() {
  [ -f "$1" ] || fail "Required file not found: $1"
}

wait_container_healthy() {
  name="$1"
  timeout="${2:-120}"
  elapsed=0

  log "Waiting for $name to become healthy"

  while [ "$elapsed" -lt "$timeout" ]; do
    status="$(docker inspect -f '{{.State.Health.Status}}' "$name" 2>/dev/null || true)"

    if [ "$status" = "healthy" ]; then
      log "$name is healthy"
      return 0
    fi

    sleep 5
    elapsed=$((elapsed + 5))
  done

  docker ps --filter "name=$name"
  docker logs --tail=80 "$name" || true
  fail "$name did not become healthy"
}

wait_http() {
  url="$1"
  timeout="${2:-120}"
  elapsed=0

  log "Waiting for HTTP endpoint: $url"

  while [ "$elapsed" -lt "$timeout" ]; do
    if curl -fsS "$url" >/dev/null 2>&1; then
      log "HTTP endpoint ready: $url"
      return 0
    fi

    sleep 5
    elapsed=$((elapsed + 5))
  done

  fail "HTTP endpoint not ready: $url"
}

compose_file_for_stack() {
  stack="$1"

  if [ -f "$RUNTIME_DIR/$stack/compose.yml" ]; then
    echo "$RUNTIME_DIR/$stack/compose.yml"
    return
  fi

  if [ -f "$RUNTIME_DIR/$stack/docker-compose.yml" ]; then
    echo "$RUNTIME_DIR/$stack/docker-compose.yml"
    return
  fi

  fail "Compose file not found for stack: $stack"
}

env_name_for_stack() {
  stack="$1"

  case "$stack" in
    mundial2026)
      echo "mundial"
      ;;
    *)
      echo "$stack"
      ;;
  esac
}

run_compose_stack() {
  stack="$1"
  shift

  env_name="$(env_name_for_stack "$stack")"
  env_file="$ENV_DIR/$env_name.env"
  compose_file="$(compose_file_for_stack "$stack")"

  require_file "$env_file"
  require_file "$compose_file"

  docker compose \
    --env-file "$env_file" \
    -f "$compose_file" \
    "$@"
}
