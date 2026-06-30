#!/bin/sh

runtime_load log

runtime_log_info "Platform status"

printf "\n"
printf "Dockside Platform\n"
printf "=================\n\n"

printf "%-18s %s\n" "Version" "$(cat "$DOCKSIDE_ROOT/VERSION")"
printf "%-18s %s\n" "Root" "$DOCKSIDE_ROOT"
printf "%-18s %s\n" "Adapter" "qts"

printf "\n"
