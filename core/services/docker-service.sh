#!/bin/sh

docker_service_check() {

    runtime_load docker
    runtime_load log

    if ! runtime_docker_exists; then
        runtime_log_error "Docker is not installed"
        return 1
    fi

    if ! runtime_docker_compose_exists; then
        runtime_log_error "Docker Compose is not available"
        return 1
    fi

    runtime_log_info "Docker runtime OK"

    return 0
}
