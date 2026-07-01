#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/application/app.sh"
. "$DOCKSIDE_HOME/scripts/platform/platform.sh"

app_stop_current
platform_stop
