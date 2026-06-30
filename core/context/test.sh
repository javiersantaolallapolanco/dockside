#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$SELF_DIR/context.sh"

echo "ROOT      : $DOCKSIDE_ROOT"
echo "CONFIG    : $DOCKSIDE_CONFIG_DIR"
echo "ADAPTERS  : $DOCKSIDE_ADAPTERS_DIR"
echo "TEMPLATES : $DOCKSIDE_TEMPLATE_DIR"

echo
echo "Context OK"
