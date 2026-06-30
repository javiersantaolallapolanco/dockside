#!/bin/sh
set -eu

runtime_load log
runtime_load filesystem

runtime_log_info "Checking Dockside installation"

dirs="
config
templates
core
stdlib
adapters
"

failed=0

for dir in $dirs
do
    if runtime_fs_is_dir "$DOCKSIDE_ROOT/$dir"; then
        printf "[ OK ] %s\n" "$dir"
    else
        printf "[FAIL] %s\n" "$dir"
        failed=1
    fi
done

if [ "$failed" -ne 0 ]; then
    runtime_log_fatal "Installation check failed"
fi

runtime_log_info "Installation looks good"
