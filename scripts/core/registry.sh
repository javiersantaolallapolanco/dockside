#!/bin/sh

. "$DOCKSIDE_HOME/scripts/core/config.sh"

registry_platform_dir() {
    printf '%s\n' "$STACKS_DIR"
}

registry_apps_dir() {
    printf '%s\n' "${APPS_DIR:-$DOCKER_ROOT/apps}"
}

registry_exists() {

    type="$1"
    name="$2"

    case "$type" in

        platform)
            [ -d "$(registry_platform_dir)/$name" ]
            ;;

        app)
            [ -d "$(registry_apps_dir)/$name" ]
            ;;

        *)
            return 1
            ;;

    esac

}

registry_dir() {

    type="$1"
    name="$2"

    case "$type" in

        platform)
            printf '%s\n' "$(registry_platform_dir)/$name"
            ;;

        app)
            printf '%s\n' "$(registry_apps_dir)/$name"
            ;;

        *)
            die "Unknown registry type: $type"
            ;;

    esac

}

registry_compose() {

    dir="$1"

    if [ -f "$dir/compose.yml" ]; then
        printf '%s\n' "$dir/compose.yml"
        return
    fi

    if [ -f "$dir/docker-compose.yml" ]; then
        printf '%s\n' "$dir/docker-compose.yml"
        return
    fi

    die "Compose not found: $dir"

}
