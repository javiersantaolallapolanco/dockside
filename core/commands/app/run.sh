#!/bin/sh
set -eu

runtime_load log
runtime_load compose

. "$DOCKSIDE_ROOT/core/services/app/app-service.sh"

APP_SUBCOMMAND="${1:-help}"
[ "$#" -gt 0 ] && shift

app_usage() {
    cat <<'USAGE'
Usage:
  dockside app create <name> --image <image> --port <host-port>
  dockside app deploy <name>
  dockside app status <name>
  dockside app list

Options:
  --force       Allow create to reuse an existing app directory
  --no-pull     Skip image pull during deploy
  --no-build    Skip build during deploy
USAGE
}

case "$APP_SUBCOMMAND" in
    create)
        APP_NAME="${1:-}"
        [ "$#" -gt 0 ] && shift

        APP_IMAGE=""
        APP_PORT=""
        APP_FORCE="no"

        while [ "$#" -gt 0 ]
        do
            case "$1" in
                --image)
                    [ "$#" -ge 2 ] || runtime_log_fatal "--image requires a value"
                    APP_IMAGE="$2"
                    shift 2
                    ;;
                --port)
                    [ "$#" -ge 2 ] || runtime_log_fatal "--port requires a value"
                    APP_PORT="$2"
                    shift 2
                    ;;
                --force)
                    APP_FORCE="yes"
                    shift
                    ;;
                *)
                    runtime_log_fatal "Unknown app create option: $1"
                    ;;
            esac
        done

        [ -n "$APP_NAME" ] || runtime_log_fatal "App name is required"
        [ -n "$APP_IMAGE" ] || runtime_log_fatal "--image is required"
        [ -n "$APP_PORT" ] || runtime_log_fatal "--port is required"

        printf "\n"
        printf "Dockside App Create\n"
        printf "%s\n\n" "============================"
        printf "%-18s %s\n" "Name" "$APP_NAME"
        printf "%-18s %s\n" "Image" "$APP_IMAGE"
        printf "%-18s %s\n" "Port" "$APP_PORT"
        printf "\n"

        app_create "$APP_NAME" "$APP_IMAGE" "$APP_PORT" "$APP_FORCE"
        ;;

    deploy)
        APP_NAME="${1:-}"
        [ "$#" -gt 0 ] && shift

        APP_PULL="yes"
        APP_BUILD="yes"

        while [ "$#" -gt 0 ]
        do
            case "$1" in
                --no-pull)
                    APP_PULL="no"
                    shift
                    ;;
                --no-build)
                    APP_BUILD="no"
                    shift
                    ;;
                *)
                    runtime_log_fatal "Unknown app deploy option: $1"
                    ;;
            esac
        done

        [ -n "$APP_NAME" ] || runtime_log_fatal "App name is required"

        printf "\n"
        printf "Dockside App Deploy\n"
        printf "%s\n\n" "============================"
        printf "%-18s %s\n" "Name" "$APP_NAME"
        printf "%-18s %s\n" "Pull" "$APP_PULL"
        printf "%-18s %s\n" "Build" "$APP_BUILD"
        printf "\n"

        app_deploy "$APP_NAME" "$APP_PULL" "$APP_BUILD"
        ;;

    status)
        APP_NAME="${1:-}"
        [ -n "$APP_NAME" ] || runtime_log_fatal "App name is required"
        app_status "$APP_NAME"
        ;;

    list)
        app_list
        ;;

    help|-h|--help)
        app_usage
        ;;

    *)
        runtime_log_fatal "Unknown app command: $APP_SUBCOMMAND"
        ;;
esac
