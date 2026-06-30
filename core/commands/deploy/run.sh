#!/bin/sh

runtime_load log

. "$DOCKSIDE_ROOT/core/services/catalog-service.sh"
. "$DOCKSIDE_ROOT/core/services/compose/compose-service.sh"

mode="${1:-run}"

runtime_log_info "Starting Dockside deploy"

for stack in $(catalog_list)
do
    if [ "$mode" = "--plan" ]; then
        echo "Would deploy: $stack"
        continue
    fi

    compose_service_run_stack "$stack" pull || true
    compose_service_run_stack "$stack" up -d
done

runtime_log_info "Dockside deploy finished"
