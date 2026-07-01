#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/config.sh"

compose_dir() {
  type="$1"
  name="$2"

  config_load

  case "$type" in
    platform)
      printf '%s\n' "$STACKS_DIR/$name"
      ;;
    app)
      printf '%s\n' "${APPS_DIR:-$DOCKER_ROOT/apps}/$name"
      ;;
    *)
      die "Invalid compose type: $type"
      ;;
  esac
}

compose_file() {
  dir="$1"

  if [ -f "$dir/compose.yml" ]; then
    printf '%s\n' "$dir/compose.yml"
    return 0
  fi

  if [ -f "$dir/docker-compose.yml" ]; then
    printf '%s\n' "$dir/docker-compose.yml"
    return 0
  fi

  die "Compose file not found: $dir"
}

compose_env() {
  type="$1"
  name="$2"
  dir="$3"

  if [ "$type" = "app" ] && [ -f "$dir/.env" ]; then
    printf '%s\n' "$dir/.env"
    return 0
  fi

  if [ -f "$ENV_DIR/$name.env" ]; then
    printf '%s\n' "$ENV_DIR/$name.env"
    return 0
  fi

  if [ -f "$dir/.env" ]; then
    printf '%s\n' "$dir/.env"
    return 0
  fi

  printf '%s\n' ""
}

compose_exec() {
  type="$1"
  name="$2"
  shift 2

  require_command docker

  dir=$(compose_dir "$type" "$name")
  require_dir "$dir"

  file=$(compose_file "$dir")
  env=$(compose_env "$type" "$name" "$dir")

  if [ -n "$env" ]; then
    docker compose --env-file "$env" -f "$file" "$@"
  else
    docker compose -f "$file" "$@"
  fi
}

compose_ids() {
  compose_exec "$1" "$2" ps -q
}

compose_wait() {
  type="$1"
  name="$2"

  config_load
  elapsed=0

  while [ "$elapsed" -le "$WAIT_TIMEOUT" ]; do
    ids=$(compose_ids "$type" "$name" || true)

    if [ -n "$ids" ]; then
      ok=1

      for id in $ids; do
        running=$(docker inspect -f '{{.State.Running}}' "$id" 2>/dev/null || echo false)
        health=$(docker inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}none{{end}}' "$id" 2>/dev/null || echo none)

        [ "$running" = "true" ] || ok=0

        if [ "$health" = "starting" ] || [ "$health" = "unhealthy" ]; then
          ok=0
        fi
      done

      if [ "$ok" = "1" ]; then
        info "Ready: $type/$name"
        return 0
      fi
    fi

    sleep "$WAIT_INTERVAL"
    elapsed=$((elapsed + WAIT_INTERVAL))
  done

  warn "Timeout waiting: $type/$name"
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

  warn "HTTP timeout: $label"
  return 0
}
