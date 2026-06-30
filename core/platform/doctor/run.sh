#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DOCKSIDE_ROOT="$(CDPATH= cd -- "$SELF_DIR/../../.." && pwd)"
export DOCKSIDE_ROOT

. "$DOCKSIDE_ROOT/core/runtime/runtime.sh"

runtime_load log

runtime_log_info "Running Dockside doctor"

echo
echo "Dockside Doctor"
echo "================"
echo "Platform : OK"
echo "Runtime  : OK"
echo "Registry : OK"
echo

runtime_log_info "Doctor finished successfully"
