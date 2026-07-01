#!/bin/sh

. "$(dirname "$0")/common.sh"

"$ROOT/bin/dockside" init >/dev/null

run init test -f "$DOCKSIDE_INSTALL_DIR/dockside.env"
