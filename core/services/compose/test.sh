#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DOCKSIDE_ROOT="$(CDPATH= cd -- "$SELF_DIR/../../.." && pwd)"
export DOCKSIDE_ROOT

. "$DOCKSIDE_ROOT/core/runtime/runtime.sh"
runtime_load log
runtime_load compose

. "$SELF_DIR/compose-service.sh"

mkdir -p "$DOCKSIDE_ROOT/config/stacks" "$DOCKSIDE_ROOT/work/test"

cat > "$DOCKSIDE_ROOT/work/test/compose.yml" <<EOT
services: {}
EOT

cat > "$DOCKSIDE_ROOT/config/stacks/test.conf" <<EOT
COMPOSE_FILE=work/test/compose.yml
ENV_FILE=
EOT

compose_service_load_stack test

rm -f "$DOCKSIDE_ROOT/config/stacks/test.conf"
rm -rf "$DOCKSIDE_ROOT/work/test"

echo "Compose service OK"
