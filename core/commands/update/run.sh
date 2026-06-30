#!/bin/sh
set -eu

runtime_load log
runtime_load compose

. "$DOCKSIDE_ROOT/core/services/update/update-service.sh"

UPDATE_STACK=""
UPDATE_PULL="yes"
UPDATE_BUILD="yes"
UPDATE_RESTART="yes"

update_usage() {
    cat <<'USAGE'
Usage:
  dockside update
  dockside update --stack <name>
  dockside update --no-pull
  dockside update --no-build
  dockside update --no-restart

Options:
  --stack NAME     Update only one catalog stack
  --no-pull        Skip docker compose pull
  --no-build       Skip docker compose build
  --no-restart     Validate/pull/build but do not run up -d
USAGE
}

while [ "$#" -gt 0 ]
do
    case "$1" in
        --stack)
            [ "$#" -ge 2 ] || runtime_log_fatal "--stack requires a value"
            UPDATE_STACK="$2"
            shift 2
            ;;
        --no-pull)
            UPDATE_PULL="no"
            shift
            ;;
        --no-build)
            UPDATE_BUILD="no"
            shift
            ;;
        --no-restart)
            UPDATE_RESTART="no"
            shift
            ;;
        --help|-h)
            update_usage
            exit 0
            ;;
        *)
            runtime_log_fatal "Unknown update option: $1"
            ;;
    esac
done

printf "\n"
printf "Dockside Update\n"
printf "%s\n\n" "============================"
if [ -n "$UPDATE_STACK" ]; then
    printf "%-18s %s\n" "Stack" "$UPDATE_STACK"
else
    printf "%-18s %s\n" "Stack" "all"
fi
printf "%-18s %s\n" "Pull" "$UPDATE_PULL"
printf "%-18s %s\n" "Build" "$UPDATE_BUILD"
printf "%-18s %s\n" "Restart" "$UPDATE_RESTART"
printf "\n"

update_all "$UPDATE_STACK" "$UPDATE_PULL" "$UPDATE_BUILD" "$UPDATE_RESTART"

printf "\n"
runtime_log_info "Update finished"
