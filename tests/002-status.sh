#!/bin/sh

. "$(dirname "$0")/common.sh"

"$ROOT/bin/dockside" status >/dev/null

pass status
