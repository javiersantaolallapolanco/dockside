#!/bin/sh

. "$DOCKSIDE_ROOT/core/services/config/config.sh"

environment_check_required() {

    config_file="$1"

    if [ ! -f "$config_file" ]; then
        printf '%s\n' "Configuration file not found: $config_file"
        return 1
    fi

    while IFS= read -r line
    do
        case "$line" in
            ""|\#*)
                continue
                ;;
        esac

        key="${line%%=*}"

        value="$(config_get "$key" "$config_file")"

        if [ -z "$value" ]; then
            printf '%s\n' "Missing: $key"
            return 1
        fi

    done < "$config_file"

    return 0
}
