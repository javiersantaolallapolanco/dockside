#!/bin/sh

runtime_load log

. "$DOCKSIDE_ROOT/core/services/compose/compose-service.sh"

runtime_log_info "Starting Dockside deploy"

if [ ! -d "$DOCKSIDE_ROOT/config/stacks" ]; then
    runtime_log_warn "No stacks configured"
    return 0
fi

found=0

for conf in "$DOCKSIDE_ROOT"/config/stacks/*.conf
do
    if [ ! -f "$conf" ]; then
        continue
    fi

    found=1
    stack="$(basename "$conf" .conf)"

    compose_service_run_stack "$stack" pull || true
    compose_service_run_stack "$stack" up -d
done

if [ "$found" -eq 0 ]; then
    runtime_log_warn "No stack config files found"
fi

runtime_log_info "Dockside deploy finished"
