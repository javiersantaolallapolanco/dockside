#!/bin/sh
set -eu

DOCKSIDE_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)"
export DOCKSIDE_ROOT

"$DOCKSIDE_ROOT/bin/dockside" backup --help >/dev/null
