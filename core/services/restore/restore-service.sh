#!/bin/sh

restore_fail() {
    runtime_load log
    runtime_log_fatal "$1"
}

restore_backup_root() {
    if [ -n "${DOCKSIDE_BACKUP_DIR:-}" ]; then
        printf '%s\n' "$DOCKSIDE_BACKUP_DIR"
    else
        printf '%s\n' "$DOCKSIDE_ROOT/backups"
    fi
}

restore_latest_stamp() {
    root="$(restore_backup_root)"

    [ -d "$root" ] || return 1

    find "$root" -mindepth 1 -maxdepth 1 -type d 2>/dev/null \
        | sed 's#^.*/##' \
        | sort \
        | tail -n 1
}

restore_backup_stamp_dir() {
    stamp="$1"
    root="$(restore_backup_root)"
    printf '%s\n' "$root/$stamp"
}

restore_stack_backup_dir() {
    stamp="$1"
    stack="$2"

    printf '%s\n' "$(restore_backup_stamp_dir "$stamp")/$stack"
}

restore_resolve_stamp() {
    requested="$1"

    if [ -n "$requested" ]; then
        printf '%s\n' "$requested"
        return 0
    fi

    restore_latest_stamp
}

restore_read_meta_value() {
    meta="$1"
    key="$2"

    grep "^$key=" "$meta" | sed "s/^$key=//" | tail -n 1
}

restore_copy_with_backup() {
    source="$1"
    target="$2"
    dry_run="$3"

    if [ ! -f "$source" ]; then
        return 0
    fi

    if [ "$dry_run" = "yes" ]; then
        printf "DRY-RUN restore %s -> %s\n" "$source" "$target"
        return 0
    fi

    if [ -f "$target" ]; then
        cp "$target" "$target.bak.$(date +%Y%m%d%H%M%S)"
    fi

    mkdir -p "$(dirname "$target")"
    cp "$source" "$target"
}

restore_stack() {
    stack="$1"
    stamp="$2"
    dry_run="$3"

    runtime_load log

    backup_dir="$(restore_stack_backup_dir "$stamp" "$stack")"
    meta="$backup_dir/backup.meta"

    [ -d "$backup_dir" ] || restore_fail "Backup stack directory not found: $backup_dir"
    [ -f "$meta" ] || restore_fail "Backup metadata not found: $meta"

    compose_file="$(restore_read_meta_value "$meta" COMPOSE_FILE)"
    env_file="$(restore_read_meta_value "$meta" ENV_FILE)"

    runtime_log_info "Restoring stack: $stack"

    if [ -n "$compose_file" ]; then
        source_compose=""
        base_compose="$(basename "$compose_file")"

        if [ -f "$backup_dir/$base_compose" ]; then
            source_compose="$backup_dir/$base_compose"
        fi

        if [ -n "$source_compose" ]; then
            restore_copy_with_backup "$source_compose" "$compose_file" "$dry_run"
        fi
    fi

    if [ -n "$env_file" ]; then
        source_env=""
        base_env="$(basename "$env_file")"

        if [ -f "$backup_dir/$base_env" ]; then
            source_env="$backup_dir/$base_env"
        fi

        if [ -n "$source_env" ]; then
            restore_copy_with_backup "$source_env" "$env_file" "$dry_run"
        fi
    fi

    if [ -d "$backup_dir/catalog-stack" ]; then
        target_stack="$DOCKSIDE_ROOT/catalog/stacks/$stack"

        if [ "$dry_run" = "yes" ]; then
            printf "DRY-RUN restore %s -> %s\n" "$backup_dir/catalog-stack" "$target_stack"
        else
            if [ -d "$target_stack" ]; then
                cp -R "$target_stack" "$target_stack.bak.$(date +%Y%m%d%H%M%S)"
                rm -rf "$target_stack"
            fi
            mkdir -p "$(dirname "$target_stack")"
            cp -R "$backup_dir/catalog-stack" "$target_stack"
        fi
    fi

    if [ -f "$backup_dir/$stack.conf" ]; then
        target_conf="$DOCKSIDE_ROOT/catalog/config/$stack.conf"
        restore_copy_with_backup "$backup_dir/$stack.conf" "$target_conf" "$dry_run"
    fi
}

restore_all() {
    selected_stack="$1"
    requested_stamp="$2"
    dry_run="$3"

    runtime_load log

    . "$DOCKSIDE_ROOT/core/services/catalog-service.sh"

    stamp="$(restore_resolve_stamp "$requested_stamp")"
    [ -n "$stamp" ] || restore_fail "No backup found"

    stamp_dir="$(restore_backup_stamp_dir "$stamp")"
    [ -d "$stamp_dir" ] || restore_fail "Backup not found: $stamp_dir"

    if [ -n "$selected_stack" ]; then
        restore_stack "$selected_stack" "$stamp" "$dry_run"
        return 0
    fi

    for stack_dir in "$stamp_dir"/*
    do
        [ -d "$stack_dir" ] || continue
        stack="$(basename "$stack_dir")"
        restore_stack "$stack" "$stamp" "$dry_run"
    done
}
