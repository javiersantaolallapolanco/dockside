#!/bin/sh

. "$(dirname "$0")/common.sh"

. "$DOCKSIDE_INSTALL_DIR/dockside.env"

APPS_DIR="${APPS_DIR:-$DOCKER_ROOT/apps}"
index_file="$APPS_DIR/index"

before_status=$("$ROOT/bin/dockside" status)
before_index=""
[ ! -f "$index_file" ] || before_index=$(cat "$index_file")

if "$ROOT/bin/dockside" update esto-no-existe >/tmp/dockside-update-invalid.out 2>&1; then
  cat /tmp/dockside-update-invalid.out
  fail "update invalid target should fail"
fi

grep -q "Unknown update target: esto-no-existe" /tmp/dockside-update-invalid.out

after_status=$("$ROOT/bin/dockside" status)
after_index=""
[ ! -f "$index_file" ] || after_index=$(cat "$index_file")

[ "$before_status" = "$after_status" ] || fail "invalid update changed status"
[ "$before_index" = "$after_index" ] || fail "invalid update changed index"

pass update-invalid-target
