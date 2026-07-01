#!/bin/sh
set -eu

. "$DOCKSIDE_HOME/scripts/lib/install.sh"

repo="${1:-}"

[ -n "$repo" ] || die "Usage: dockside install <repo>"

app_install "$repo"
