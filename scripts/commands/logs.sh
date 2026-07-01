#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/services/logs.sh"

logs_show "${1:-}"
