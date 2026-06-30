#!/bin/sh
set -eu

. "$(dirname "$0")/filesystem.sh"

TMP="/tmp/dockside-test"

runtime_fs_remove "$TMP"

runtime_fs_mkdir "$TMP"

if runtime_fs_is_dir "$TMP"; then
    echo "Filesystem runtime OK"
else
    echo "Filesystem runtime FAILED"
    exit 1
fi

runtime_fs_remove "$TMP"
