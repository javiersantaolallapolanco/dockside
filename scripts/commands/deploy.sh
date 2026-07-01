#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/services/deploy.sh"

deploy_run "${1:-}"
