#!/bin/sh

runtime_load log
runtime_load docker
runtime_load filesystem

runtime_log_info "Initializing Dockside"

WORKDIR="$DOCKSIDE_ROOT/work"

printf "\n"
printf "Dockside Init\n"
printf "============================\n\n"

if runtime_fs_is_dir "$WORKDIR"; then
    echo "[ OK ] Work directory"
else
    runtime_fs_mkdir "$WORKDIR"
    echo "[NEW] Work directory created"
fi

if runtime_docker_exists; then
    echo "[ OK ] Docker"
else
    runtime_log_fatal "Docker not found"
fi

if runtime_docker_compose_exists; then
    echo "[ OK ] Docker Compose"
else
    runtime_log_fatal "Docker Compose not found"
fi

echo
runtime_log_info "Dockside initialized successfully"
