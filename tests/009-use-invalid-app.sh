#!/bin/sh

. "$(dirname "$0")/common.sh"

before=$("$ROOT/bin/dockside" status)

if "$ROOT/bin/dockside" use esto-no-existe >/tmp/dockside-use-invalid.out 2>&1; then
  cat /tmp/dockside-use-invalid.out
  fail "use invalid app should fail"
fi

grep -q "Application is not installed: esto-no-existe" /tmp/dockside-use-invalid.out

after=$("$ROOT/bin/dockside" status)

[ "$before" = "$after" ] || fail "invalid use changed status"

pass use-invalid-app
