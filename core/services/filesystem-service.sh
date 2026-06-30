#!/bin/sh

filesystem_service_prepare_directory() {

    runtime_load filesystem

    dir="$1"

    if runtime_fs_is_dir "$dir"; then
        return 0
    fi

    runtime_fs_mkdir "$dir"
}

filesystem_service_reset_directory() {

    runtime_load filesystem

    dir="$1"

    runtime_fs_remove "$dir"
    runtime_fs_mkdir "$dir"
}
