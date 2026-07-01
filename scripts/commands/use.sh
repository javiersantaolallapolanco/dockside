#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/lib/app.sh"

app="${1:-}"
app_use "$app"
