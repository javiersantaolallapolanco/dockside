#!/bin/sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
DOCKSIDE_INSTALL_DIR="${DOCKSIDE_INSTALL_DIR:-/share/CACHEDEV1_DATA/docker/dockside}"
export DOCKSIDE_INSTALL_DIR

pass() {
  printf '[PASS] %s\n' "$1"
}

fail() {
  printf '[FAIL] %s\n' "$1"
  exit 1
}

run() {
  name="$1"
  shift

  if "$@"; then
    pass "$name"
  else
    fail "$name"
  fi
}
