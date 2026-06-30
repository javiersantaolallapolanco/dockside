#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$SELF_DIR/assert.sh"
. "$SELF_DIR/path.sh"
. "$SELF_DIR/environment.sh"
. "$SELF_DIR/os.sh"
. "$SELF_DIR/loader.sh"

assert_command_exists sh
assert_file_exists "$SELF_DIR/assert.sh"

joined="$(path_join "/tmp/" "/dockside")"
if [ "$joined" != "/tmp/dockside" ]; then
    echo "Path test FAILED"
    exit 1
fi

DOCKSIDE_TEST_VALUE="ok"
export DOCKSIDE_TEST_VALUE

value="$(env_required DOCKSIDE_TEST_VALUE)"
if [ "$value" != "ok" ]; then
    echo "Environment test FAILED"
    exit 1
fi

os_name >/dev/null

echo "Stdlib OK"
