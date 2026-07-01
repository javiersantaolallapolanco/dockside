#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/lib/logs.sh"

logs_show "${1:-}"
