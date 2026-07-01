#!/bin/sh

. "$(dirname "$0")/common.sh"

before=$("$ROOT/bin/dockside" status)

if "$ROOT/bin/dockside" remove esto-no-existe >/tmp/dockside-remove-invalid.out 2>&1; then
  cat /tmp/dockside-remove-invalid.out
  fail "remove invalid app should fail"
fi

grep -q "Application not installed: esto-no-existe" /tmp/dockside-remove-invalid.out

after=$("$ROOT/bin/dockside" status)

[ "$before" = "$after" ] || fail "invalid remove changed status"

pass remove-invalid-app
