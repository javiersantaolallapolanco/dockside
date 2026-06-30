#!/bin/sh

doctor_run() {

    runtime_load log
    runtime_load docker

    runtime_log_info "Running Dockside doctor"

    printf "\n"
    printf "Dockside Doctor\n"
    printf "=========================\n\n"

    printf "%-24s" "Shell"
    command -v sh >/dev/null && echo "OK" || echo "FAIL"

    printf "%-24s" "Git"
    command -v git >/dev/null && echo "OK" || echo "FAIL"

    printf "%-24s" "Docker"
    runtime_docker_exists && echo "OK" || echo "FAIL"

    printf "%-24s" "Docker Compose"
    runtime_docker_compose_exists && echo "OK" || echo "FAIL"

    printf "%-24s" "QTS"
    [ -d /etc/config ] && echo "YES" || echo "NO"

    printf "\n"

    runtime_log_info "Doctor completed"

}
