#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
ROOT_DIR="$(CDPATH= cd -- "$SELF_DIR/../.." && pwd)"

. "$ROOT_DIR/core/runtime/runtime.sh"

runtime_load log
runtime_load filesystem

runtime_log_info "Runtime loader OK"

TMP="/tmp/dockside-runtime"

runtime_fs_remove "$TMP"
runtime_fs_mkdir "$TMP"

runtime_fs_is_dir "$TMP"

runtime_fs_remove "$TMP"

echo "Runtime OK"
