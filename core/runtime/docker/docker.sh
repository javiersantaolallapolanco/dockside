#!/bin/sh

runtime_docker_exists() {
    command -v docker >/dev/null 2>&1
}

runtime_docker_compose_exists() {
    docker compose version >/dev/null 2>&1
}

runtime_docker_ps() {
    docker ps "$@"
}

runtime_docker_compose() {
    docker compose "$@"
}

runtime_docker_version() {
    docker version --format '{{.Server.Version}}'
}
