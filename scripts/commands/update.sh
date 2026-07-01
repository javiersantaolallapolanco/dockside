#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/services/update.sh"

update_run "${1:-all}"
