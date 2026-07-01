#!/bin/sh

. "$(dirname "$0")/common.sh"

. "$DOCKSIDE_INSTALL_DIR/dockside.env"

APPS_DIR="${APPS_DIR:-$DOCKER_ROOT/apps}"

invalid_repo="/tmp/dockside-invalid-install-repo"
app_name=$(basename "$invalid_repo")
target="$APPS_DIR/$app_name"
index_file="$APPS_DIR/index"

rm -rf "$invalid_repo" "$target"
mkdir -p "$invalid_repo"

before_status=$("$ROOT/bin/dockside" status)
before_index=""
[ ! -f "$index_file" ] || before_index=$(cat "$index_file")

if "$ROOT/bin/dockside" install "$invalid_repo" >/tmp/dockside-install-invalid.out 2>&1; then
  cat /tmp/dockside-install-invalid.out
  fail "install invalid repo should fail"
fi

grep -q "Compose file not found" /tmp/dockside-install-invalid.out

after_status=$("$ROOT/bin/dockside" status)
after_index=""
[ ! -f "$index_file" ] || after_index=$(cat "$index_file")

[ "$before_status" = "$after_status" ] || fail "invalid install changed status"
[ "$before_index" = "$after_index" ] || fail "invalid install changed index"
[ ! -d "$target" ] || fail "invalid install created app directory"

rm -rf "$invalid_repo"

pass install-invalid-repo
