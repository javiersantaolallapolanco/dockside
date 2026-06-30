#!/bin/sh

doctor_ok=0
doctor_fail=0
doctor_warn=0

doctor_print_result() {
    status="$1"
    name="$2"
    detail="${3:-}"

    printf "%-34s %s" "$name" "$status"

    if [ -n "$detail" ]; then
        printf "  %s" "$detail"
    fi

    printf "\n"
}

doctor_check() {
    name="$1"
    shift

    if "$@" >/dev/null 2>&1; then
        doctor_ok=$((doctor_ok + 1))
        doctor_print_result "OK" "$name"
    else
        doctor_fail=$((doctor_fail + 1))
        doctor_print_result "FAIL" "$name"
    fi
}

doctor_warn_check() {
    name="$1"
    shift

    if "$@" >/dev/null 2>&1; then
        doctor_ok=$((doctor_ok + 1))
        doctor_print_result "OK" "$name"
    else
        doctor_warn=$((doctor_warn + 1))
        doctor_print_result "WARN" "$name"
    fi
}

doctor_file_exists() {
    [ -f "$1" ]
}

doctor_dir_exists() {
    [ -d "$1" ]
}

doctor_env_file_valid() {
    env_file="$1"

    if [ -z "$env_file" ]; then
        return 0
    fi

    [ -f "$env_file" ]
}

doctor_stack_config_valid() {
    stack="$1"

    . "$DOCKSIDE_ROOT/core/services/compose/compose-service.sh"

    compose_service_load_stack "$stack" >/dev/null 2>&1
}

doctor_stack_env_valid() {
    stack="$1"

    . "$DOCKSIDE_ROOT/core/services/compose/compose-service.sh"

    compose_service_load_stack "$stack" >/dev/null 2>&1 || return 1

    doctor_env_file_valid "$ENV_FILE"
}

doctor_stack_compose_config_valid() {
    stack="$1"

    . "$DOCKSIDE_ROOT/core/services/compose/compose-service.sh"

    compose_service_load_stack "$stack" >/dev/null 2>&1 || return 1

    runtime_load compose
    runtime_compose_run "$ENV_FILE" "$COMPOSE_FILE" config >/dev/null 2>&1
}

doctor_run() {
    runtime_load log
    runtime_load docker
    runtime_load compose
    runtime_load filesystem

    . "$DOCKSIDE_ROOT/core/services/catalog-service.sh"

    runtime_log_info "Running Dockside doctor"

    printf "\n"
    printf "Dockside Doctor\n"
    printf "============================\n\n"

    doctor_check "Shell" command -v sh
    doctor_check "Git" command -v git
    doctor_check "Docker binary" runtime_docker_exists
    doctor_check "Docker Compose" runtime_compose_exists

    doctor_check "Dockside root" doctor_dir_exists "$DOCKSIDE_ROOT"
    doctor_check "Catalog index" doctor_file_exists "$DOCKSIDE_ROOT/catalog/index/stacks.conf"
    doctor_check "Catalog config directory" doctor_dir_exists "$DOCKSIDE_ROOT/catalog/config"
    doctor_check "Catalog stacks directory" doctor_dir_exists "$DOCKSIDE_ROOT/catalog/stacks"
    doctor_check "Config directory" doctor_dir_exists "$DOCKSIDE_ROOT/config"
    doctor_check "Templates directory" doctor_dir_exists "$DOCKSIDE_ROOT/templates"

    doctor_warn_check "QTS environment" doctor_dir_exists /etc/config

    printf "\n"
    printf "Catalog stacks\n"
    printf "----------------------------\n"

    if ! stacks="$(catalog_list)"; then
        doctor_fail=$((doctor_fail + 1))
        doctor_print_result "FAIL" "Catalog readable"
    else
        if [ -z "$stacks" ]; then
            doctor_fail=$((doctor_fail + 1))
            doctor_print_result "FAIL" "Catalog not empty"
        fi

        for stack in $stacks
        do
            doctor_check "$stack config" doctor_stack_config_valid "$stack"
            doctor_check "$stack env file" doctor_stack_env_valid "$stack"
            doctor_check "$stack compose config" doctor_stack_compose_config_valid "$stack"
        done
    fi

    printf "\n"
    printf "Summary\n"
    printf "----------------------------\n"
    printf "OK:   %s\n" "$doctor_ok"
    printf "WARN: %s\n" "$doctor_warn"
    printf "FAIL: %s\n" "$doctor_fail"
    printf "\n"

    if [ "$doctor_fail" -ne 0 ]; then
        runtime_log_fatal "Doctor failed"
    fi

    runtime_log_info "Doctor finished"
}
