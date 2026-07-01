#!/bin/sh

. "$(dirname "$0")/common.sh"

"$ROOT/bin/dockside" doctor >/dev/null

pass doctor
