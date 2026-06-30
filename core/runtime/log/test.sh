#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DOCKSIDE_ROOT="$(CDPATH= cd -- "$SELF_DIR/../../.." && pwd)"
export DOCKSIDE_ROOT

. "$DOCKSIDE_ROOT/core/runtime/runtime.sh"

runtime_load log

runtime_log_info "Info message"
runtime_log_warn "Warning message"
runtime_log_error "Error message"

echo "Log runtime OK"
