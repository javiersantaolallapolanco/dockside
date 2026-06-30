#!/bin/sh
set -eu

DOCKSIDE_ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)"
export DOCKSIDE_ROOT

"$DOCKSIDE_ROOT/bin/dockside" app --help >/dev/null

TEST_ROOT="/tmp/dockside-app-test-$$"
DOCKSIDE_APPS_DIR="$TEST_ROOT"
export DOCKSIDE_APPS_DIR

"$DOCKSIDE_ROOT/bin/dockside" app create demo --image nginx:alpine --port 18080 >/dev/null
[ -f "$TEST_ROOT/demo/docker-compose.yml" ]
[ -f "$TEST_ROOT/demo/.env" ]
[ -f "$TEST_ROOT/demo/app.conf" ]

"$DOCKSIDE_ROOT/bin/dockside" app list | grep -q '^demo$'
"$DOCKSIDE_ROOT/bin/dockside" app status demo >/dev/null

rm -rf "$TEST_ROOT"
