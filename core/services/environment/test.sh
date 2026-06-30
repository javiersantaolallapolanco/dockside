#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
export DOCKSIDE_ROOT="$(CDPATH= cd -- "$SELF_DIR/../../.." && pwd)"

. "$SELF_DIR/environment.sh"

cat >/tmp/dockside-env-test.env <<EOT
NAME=dockside
VERSION=0.1
EOT

environment_check_required /tmp/dockside-env-test.env

rm -f /tmp/dockside-env-test.env

echo "Environment service OK"
