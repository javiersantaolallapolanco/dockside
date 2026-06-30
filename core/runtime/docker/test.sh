#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DOCKSIDE_ROOT="$(CDPATH= cd -- "$SELF_DIR/../../.." && pwd)"
export DOCKSIDE_ROOT

. "$DOCKSIDE_ROOT/core/runtime/runtime.sh"

runtime_load docker

runtime_docker_exists
runtime_docker_compose_exists

printf "Docker Version: "
runtime_docker_version

echo "Docker runtime OK"
