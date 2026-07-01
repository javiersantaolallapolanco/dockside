#!/bin/sh
set -eu

DOCKSIDE_HOME="${DOCKSIDE_HOME:-$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)}"

log() { printf '%s\n' "$*"; }
info() { log "[INFO] $*"; }
warn() { log "[WARN] $*" >&2; }
error() { log "[ERROR] $*" >&2; }
die() { error "$*"; exit 1; }

timestamp() { date '+%Y-%m-%dT%H:%M:%S'; }

require_command() {
  command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"
}

require_dir() {
  [ -d "$1" ] || die "Missing directory: $1"
}

require_file() {
  [ -f "$1" ] || die "Missing file: $1"
}


wait_http() {
    url="$1"
    name="$2"

    [ -n "$url" ] || die "Missing health URL for: $name"

    timeout="${HTTP_WAIT_TIMEOUT:-30}"
    elapsed=0

    while [ "$elapsed" -lt "$timeout" ]; do
        if curl -fsS "$url" >/dev/null 2>&1; then
            info "HTTP ready: $name"
            return 0
        fi

        sleep 1
        elapsed=$((elapsed + 1))
    done

    die "Timeout waiting for HTTP: $name"
}
