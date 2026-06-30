#!/bin/sh

set -eu

DOCKSIDE_HOME=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)

PLATFORM_DIR="$DOCKSIDE_HOME/platform"
STACKS_DIR="$PLATFORM_DIR/stacks"
ENV_DIR="$PLATFORM_DIR/env"
STATE_DIR="$PLATFORM_DIR/state"
BACKUPS_DIR="$PLATFORM_DIR/backups"
APPS_DIR="$DOCKSIDE_HOME/apps"

PLATFORM_ENV="$ENV_DIR/platform.env"
STATE_FILE="$STATE_DIR/state.env"

log() {
    printf '%s\n' "$*"
}

info() {
    log "[INFO] $*"
}

warn() {
    log "[WARN] $*" >&2
}

error() {
    log "[ERROR] $*" >&2
}

die() {
    error "$*"
    exit 1
}

require_command() {
    command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"
}

require_file() {
    [ -f "$1" ] || die "Missing file: $1"
}

require_directory() {
    [ -d "$1" ] || die "Missing directory: $1"
}

timestamp() {
    date '+%Y-%m-%dT%H:%M:%S'
}
