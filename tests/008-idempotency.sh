#!/bin/sh

. "$(dirname "$0")/common.sh"

"$ROOT/bin/dockside" init >/dev/null
"$ROOT/bin/dockside" init >/dev/null

"$ROOT/bin/dockside" doctor >/dev/null
"$ROOT/bin/dockside" doctor >/dev/null

"$ROOT/bin/dockside" status >/dev/null
"$ROOT/bin/dockside" status >/dev/null

pass idempotency
