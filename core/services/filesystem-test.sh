#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DOCKSIDE_ROOT="$(CDPATH= cd -- "$SELF_DIR/../.." && pwd)"
export DOCKSIDE_ROOT

. "$DOCKSIDE_ROOT/core/runtime/runtime.sh"
. "$SELF_DIR/filesystem-service.sh"

TMP="/tmp/dockside-service"

filesystem_service_reset_directory "$TMP"
filesystem_service_prepare_directory "$TMP"

echo "Filesystem service OK"

runtime_load filesystem
runtime_fs_remove "$TMP"
