#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/application/app.sh"

app="${1:-}"
app_use "$app"
