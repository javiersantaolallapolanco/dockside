#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"

. "$SELF_DIR/assert.sh"

assert_command_exists sh
assert_directory_exists "$SELF_DIR"
assert_file_exists "$SELF_DIR/assert.sh"
assert_file_readable "$SELF_DIR/assert.sh"

echo "Assert runtime OK"
