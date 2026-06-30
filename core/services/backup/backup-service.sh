#!/bin/sh

backup_timestamp() {
    date +%Y%m%d%H%M%S
}

backup_root_dir() {
    if [ -n "${DOCKSIDE_BACKUP_DIR:-}" ]; then
        printf '%s\n' "$DOCKSIDE_BACKUP_DIR"
    else
        printf '%s\n' "$DOCKSIDE_ROOT/backups"
    fi
}

backup_prepare_root() {
    runtime_load filesystem

    dir="$(backup_root_dir)"
    runtime_fs_mkdir "$dir"
    printf '%s\n' "$dir"
}

backup_stack_dir() {
    stack="$1"
    stamp="$2"

    root="$(backup_prepare_root)"
    printf '%s\n' "$root/$stamp/$stack"
}

backup_copy_file_if_exists() {
    source="$1"
    target_dir="$2"

    if [ -n "$source" ] && [ -f "$source" ]; then
        mkdir -p "$target_dir"
        cp "$source" "$target_dir/"
        return 0
    fi

    return 1
}

backup_write_metadata() {
    stack="$1"
    target="$2"

    {
        printf 'STACK=%s\n' "$stack"
        printf 'DATE=%s\n' "$(date)"
        printf 'DOCKSIDE_ROOT=%s\n' "$DOCKSIDE_ROOT"
        printf 'COMPOSE_FILE=%s\n' "${COMPOSE_FILE:-}"
        printf 'ENV_FILE=%s\n' "${ENV_FILE:-}"
    } > "$target/backup.meta"
}

backup_stack() {
    stack="$1"
    stamp="$2"

    runtime_load log

    . "$DOCKSIDE_ROOT/core/services/compose/compose-service.sh"

    compose_service_load_stack "$stack"

    target="$(backup_stack_dir "$stack" "$stamp")"
    mkdir -p "$target"

    runtime_log_info "Backing up stack: $stack"

    backup_write_metadata "$stack" "$target"

    backup_copy_file_if_exists "$COMPOSE_FILE" "$target" || true
    backup_copy_file_if_exists "$ENV_FILE" "$target" || true

    if [ -d "$DOCKSIDE_ROOT/catalog/stacks/$stack" ]; then
        cp -R "$DOCKSIDE_ROOT/catalog/stacks/$stack" "$target/catalog-stack"
    fi

    if [ -f "$DOCKSIDE_ROOT/catalog/config/$stack.conf" ]; then
        cp "$DOCKSIDE_ROOT/catalog/config/$stack.conf" "$target/"
    fi

    printf '%s\n' "$target"
}

backup_all() {
    selected_stack="$1"
    stamp="$2"

    runtime_load log

    . "$DOCKSIDE_ROOT/core/services/catalog-service.sh"

    stacks="$(catalog_list)"

    if [ -z "$stacks" ]; then
        runtime_log_fatal "No stacks defined in catalog"
    fi

    if [ -n "$selected_stack" ] && ! catalog_exists "$selected_stack"; then
        runtime_log_fatal "Stack not found in catalog: $selected_stack"
    fi

    for stack in $stacks
    do
        if [ -z "$selected_stack" ] || [ "$stack" = "$selected_stack" ]; then
            backup_stack "$stack" "$stamp"
        fi
    done
}
