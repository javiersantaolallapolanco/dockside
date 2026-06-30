#!/bin/sh

update_selected_stack_exists() {
    selected_stack="$1"

    if [ -z "$selected_stack" ]; then
        return 0
    fi

    . "$DOCKSIDE_ROOT/core/services/catalog-service.sh"

    catalog_exists "$selected_stack"
}

update_stack_selected() {
    stack="$1"
    selected_stack="$2"

    if [ -z "$selected_stack" ]; then
        return 0
    fi

    [ "$stack" = "$selected_stack" ]
}

update_stack() {
    stack="$1"
    pull="$2"
    build="$3"
    restart="$4"

    runtime_load log

    . "$DOCKSIDE_ROOT/core/services/compose/compose-service.sh"

    runtime_log_info "Updating stack: $stack"

    compose_service_run_stack "$stack" config >/dev/null

    if [ "$pull" = "yes" ]; then
        if ! compose_service_run_stack "$stack" pull; then
            runtime_log_warn "Pull failed or skipped by Compose for stack: $stack"
        fi
    fi

    if [ "$build" = "yes" ]; then
        if ! compose_service_run_stack "$stack" build; then
            runtime_log_warn "Build failed or not required for stack: $stack"
        fi
    fi

    if [ "$restart" = "yes" ]; then
        compose_service_run_stack "$stack" up -d
    fi
}

update_all() {
    selected_stack="$1"
    pull="$2"
    build="$3"
    restart="$4"

    runtime_load log

    . "$DOCKSIDE_ROOT/core/services/catalog-service.sh"

    update_selected_stack_exists "$selected_stack" || runtime_log_fatal "Stack not found in catalog: $selected_stack"

    stacks="$(catalog_list)"
    [ -n "$stacks" ] || runtime_log_fatal "No stacks defined in catalog"

    for stack in $stacks
    do
        if update_stack_selected "$stack" "$selected_stack"; then
            update_stack "$stack" "$pull" "$build" "$restart"
        fi
    done
}
