#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/lib/deploy.sh"

deploy_run "${1:-}"
