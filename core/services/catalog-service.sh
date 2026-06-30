#!/bin/sh

catalog_index_file() {
    printf '%s\n' "$DOCKSIDE_ROOT/catalog/index/stacks.conf"
}

catalog_list() {
    file="$(catalog_index_file)"

    if [ ! -f "$file" ]; then
        return 1
    fi

    while IFS= read -r line
    do
        case "$line" in
            ""|\#*)
                continue
                ;;
            *)
                printf '%s\n' "$line"
                ;;
        esac
    done < "$file"
}

catalog_exists() {
    stack="$1"
    file="$(catalog_index_file)"

    if [ ! -f "$file" ]; then
        return 1
    fi

    grep -qx "$stack" "$file"
}

catalog_config_file() {
    stack="$1"
    printf '%s\n' "$DOCKSIDE_ROOT/catalog/config/$stack.conf"
}

catalog_stack_config_exists() {
    stack="$1"
    [ -f "$(catalog_config_file "$stack")" ]
}
