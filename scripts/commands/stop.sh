#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/lib/app.sh"
. "$DOCKSIDE_HOME/scripts/lib/platform.sh"

app_stop_current
platform_stop
