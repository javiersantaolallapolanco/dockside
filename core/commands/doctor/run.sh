#!/bin/sh

runtime_load log
runtime_load docker
runtime_load filesystem

runtime_log_info "Running doctor"

printf "\n"
printf "Dockside Doctor\n"
printf "============================\n\n"

check() {
    name="$1"
    shift

    printf "%-24s" "$name"

    if "$@"; then
        echo "OK"
    else
        echo "FAIL"
    fi
}

check "Shell" command -v sh
check "Git" command -v git
check "Docker" runtime_docker_exists
check "Docker Compose" runtime_docker_compose_exists
check "QTS" test -d /etc/config
check "Config directory" runtime_fs_is_dir "$DOCKSIDE_ROOT/config"
check "Templates" runtime_fs_is_dir "$DOCKSIDE_ROOT/templates"

printf "\n"
runtime_log_info "Doctor finished"
