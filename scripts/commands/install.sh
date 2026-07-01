#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/application/install.sh"

repo="${1:-}"

[ -n "$repo" ] || die "Usage: dockside install <repo>"

app_install "$repo"
