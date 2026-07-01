#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/lib/update.sh"

update_run "${1:-all}"
