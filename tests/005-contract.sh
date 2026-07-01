#!/bin/sh

. "$(dirname "$0")/common.sh"

"$ROOT/bin/dockside" doctor >/dev/null

run contract true
