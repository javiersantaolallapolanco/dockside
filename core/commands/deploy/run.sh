#!/bin/sh
set -eu

runtime_load log
runtime_load compose

. "$DOCKSIDE_ROOT/core/services/catalog-service.sh"
. "$DOCKSIDE_ROOT/core/services/compose/compose-service.sh"

mode="${1:-run}"

case "$mode" in
    run|--run)
        ;;
    plan|--plan)
        mode="plan"
        ;;
    *)
        runtime_log_fatal "Unknown deploy mode: $mode"
        ;;
esac

runtime_log_info "Starting Dockside deploy"

stacks="$(catalog_list)"

if [ -z "$stacks" ]; then
    runtime_log_fatal "No stacks defined in catalog"
fi

printf "\n"
printf "Dockside Deploy\n"
printf "============================\n\n"

for stack in $stacks
do
    if [ "$mode" = "plan" ]; then
        compose_service_load_stack "$stack"
        printf "%-18s %s\n" "$stack" "$COMPOSE_FILE"
        continue
    fi

    runtime_log_info "Deploying stack: $stack"

    compose_service_run_stack "$stack" config >/dev/null
    compose_service_run_stack "$stack" pull || runtime_log_warn "Pull skipped or failed for stack: $stack"
    compose_service_run_stack "$stack" up -d
done

printf "\n"
runtime_log_info "Dockside deploy finished"
