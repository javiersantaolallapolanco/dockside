#!/bin/sh
set -eu

runtime_load log
runtime_load docker
runtime_load compose

. "$DOCKSIDE_ROOT/core/services/catalog-service.sh"
. "$DOCKSIDE_ROOT/core/services/compose/compose-service.sh"

STATUS_STACK=""
STATUS_VERBOSE="no"

status_usage() {
    cat <<'USAGE'
Usage:
  dockside status
  dockside status --stack <name>
  dockside status --verbose

Options:
  --stack NAME    Show status for one catalog stack
  --verbose       Show full docker compose ps output
USAGE
}

while [ "$#" -gt 0 ]
do
    case "$1" in
        --stack)
            if [ "$#" -lt 2 ]; then
                runtime_log_fatal "--stack requires a value"
            fi
            STATUS_STACK="$2"
            shift 2
            ;;
        --verbose)
            STATUS_VERBOSE="yes"
            shift
            ;;
        --help|-h)
            status_usage
            exit 0
            ;;
        *)
            runtime_log_fatal "Unknown status option: $1"
            ;;
    esac
done

status_stack_selected() {
    stack="$1"

    if [ -z "$STATUS_STACK" ]; then
        return 0
    fi

    [ "$stack" = "$STATUS_STACK" ]
}

status_print_header() {
    printf "\n"
    printf "Dockside Status\n"
    printf "%s\n\n" "============================"

    printf "%-22s %s\n" "Version" "$(cat "$DOCKSIDE_ROOT/VERSION")"
    printf "%-22s %s\n" "Root" "$DOCKSIDE_ROOT"

    if runtime_docker_exists; then
        printf "%-22s %s\n" "Docker" "$(runtime_docker_version 2>/dev/null || printf 'unknown')"
    else
        printf "%-22s %s\n" "Docker" "not found"
    fi

    if runtime_compose_exists; then
        printf "%-22s %s\n" "Compose" "available"
    else
        printf "%-22s %s\n" "Compose" "not found"
    fi

    if [ -d /etc/config ]; then
        printf "%-22s %s\n" "Host" "QTS"
    else
        printf "%-22s %s\n" "Host" "unknown"
    fi

    printf "\n"
}

status_stack_summary() {
    stack="$1"

    compose_service_load_stack "$stack"

    printf "%s\n" "----------------------------"
    printf "Stack: %s\n" "$stack"
    printf "%s\n" "----------------------------"
    printf "%-18s %s\n" "Name" "$STACK_NAME"
    printf "%-18s %s\n" "Compose" "$COMPOSE_FILE"

    if [ -n "${ENV_FILE:-}" ]; then
        printf "%-18s %s\n" "Env" "$ENV_FILE"
    else
        printf "%-18s %s\n" "Env" "-"
    fi

    if compose_service_run_stack "$stack" config >/tmp/dockside-status-config.out 2>&1; then
        printf "%-18s %s\n" "Config" "OK"
    else
        printf "%-18s %s\n" "Config" "FAIL"
        sed -n '1,8p' /tmp/dockside-status-config.out | sed 's/^/    /'
        rm -f /tmp/dockside-status-config.out
        printf "\n"
        return 1
    fi

    rm -f /tmp/dockside-status-config.out

    printf "\n"

    if [ "$STATUS_VERBOSE" = "yes" ]; then
        compose_service_run_stack "$stack" ps --all || return 1
    else
        compose_service_run_stack "$stack" ps || return 1
    fi

    printf "\n"
}

status_print_header

stacks="$(catalog_list)"

if [ -z "$stacks" ]; then
    runtime_log_fatal "No stacks defined in catalog"
fi

if [ -n "$STATUS_STACK" ] && ! catalog_exists "$STATUS_STACK"; then
    runtime_log_fatal "Stack not found in catalog: $STATUS_STACK"
fi

for stack in $stacks
do
    if status_stack_selected "$stack"; then
        status_stack_summary "$stack"
    fi
done

runtime_log_info "Status finished"
