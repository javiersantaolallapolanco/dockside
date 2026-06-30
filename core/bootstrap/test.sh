#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$SELF_DIR/bootstrap.sh"

bootstrap_init

printf '%s\n' "Bootstrap OK"
printf '%s\n' "ROOT=$DOCKSIDE_ROOT"
