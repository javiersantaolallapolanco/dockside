#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/lib/remove.sh"

app_remove "${1:-}" "${2:-}"
