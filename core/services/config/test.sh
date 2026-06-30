#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

cat > /tmp/dockside-config-test.env <<EOT
NAME=dockside
VERSION=0.1
EOT

. "$SELF_DIR/config.sh"

config_require NAME /tmp/dockside-config-test.env
config_require VERSION /tmp/dockside-config-test.env

rm -f /tmp/dockside-config-test.env

echo "Configuration service OK"
