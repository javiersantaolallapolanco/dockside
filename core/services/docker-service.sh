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

docker_service_wait_container_healthy() {
    container="$1"
    timeout="${2:-180}"

    runtime_load log

    runtime_log_info "Waiting for container healthy: $container"

    elapsed=0

    while [ "$elapsed" -lt "$timeout" ]
    do
        status="$(docker inspect --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}{{.State.Status}}{{end}}' "$container" 2>/dev/null || true)"

        if [ "$status" = "healthy" ] || [ "$status" = "running" ]; then
            runtime_log_info "Container ready: $container"
            return 0
        fi

        sleep 2
        elapsed=$((elapsed + 2))
    done

    runtime_log_error "Container not ready: $container"
    return 1
}
