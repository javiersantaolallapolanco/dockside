#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/application/remove.sh"

app_remove "${1:-}" "${2:-}"
