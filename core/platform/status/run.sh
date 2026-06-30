#!/bin/sh

. "$DOCKSIDE_ROOT/core/services/docker-service.sh"

docker_service_check

runtime_load docker

printf "\n"
printf "Dockside Platform\n"
printf "=========================\n\n"

printf "%-22s %s\n" "Version" "$(cat "$DOCKSIDE_ROOT/VERSION")"
printf "%-22s %s\n" "Root" "$DOCKSIDE_ROOT"
printf "%-22s %s\n" "Docker" "$(runtime_docker_version)"
printf "%-22s %s\n" "Adapter" "QTS"

printf "\n"
