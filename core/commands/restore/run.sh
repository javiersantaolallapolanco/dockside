#!/bin/sh
set -eu

runtime_load log
runtime_load filesystem

. "$DOCKSIDE_ROOT/core/services/restore/restore-service.sh"

RESTORE_STACK=""
RESTORE_STAMP=""
RESTORE_DIR=""
RESTORE_DRY_RUN="no"

restore_usage() {
    cat <<'USAGE'
Usage:
  dockside restore
  dockside restore --latest
  dockside restore --stamp <timestamp>
  dockside restore --stack <name>
  dockside restore --dir <path>
  dockside restore --dry-run

Options:
  --latest          Restore latest backup
  --stamp VALUE     Restore specific backup timestamp
  --stack NAME      Restore only one stack
  --dir PATH        Backup root directory
  --dry-run         Show what would be restored
USAGE
}

while [ "$#" -gt 0 ]
do
    case "$1" in
        --latest)
            RESTORE_STAMP=""
            shift
            ;;
        --stamp)
            [ "$#" -ge 2 ] || runtime_log_fatal "--stamp requires a value"
            RESTORE_STAMP="$2"
            shift 2
            ;;
        --stack)
            [ "$#" -ge 2 ] || runtime_log_fatal "--stack requires a value"
            RESTORE_STACK="$2"
            shift 2
            ;;
        --dir)
            [ "$#" -ge 2 ] || runtime_log_fatal "--dir requires a value"
            RESTORE_DIR="$2"
            shift 2
            ;;
        --dry-run)
            RESTORE_DRY_RUN="yes"
            shift
            ;;
        --help|-h)
            restore_usage
            exit 0
            ;;
        *)
            runtime_log_fatal "Unknown restore option: $1"
            ;;
    esac
done

if [ -n "$RESTORE_DIR" ]; then
    DOCKSIDE_BACKUP_DIR="$RESTORE_DIR"
    export DOCKSIDE_BACKUP_DIR
fi

printf "\n"
printf "Dockside Restore\n"
printf "%s\n\n" "============================"
printf "%-18s %s\n" "Backup root" "$(restore_backup_root)"
if [ -n "$RESTORE_STAMP" ]; then
    printf "%-18s %s\n" "Stamp" "$RESTORE_STAMP"
else
    printf "%-18s %s\n" "Stamp" "latest"
fi
if [ -n "$RESTORE_STACK" ]; then
    printf "%-18s %s\n" "Stack" "$RESTORE_STACK"
else
    printf "%-18s %s\n" "Stack" "all"
fi
printf "%-18s %s\n" "Dry run" "$RESTORE_DRY_RUN"
printf "\n"

restore_all "$RESTORE_STACK" "$RESTORE_STAMP" "$RESTORE_DRY_RUN"

printf "\n"
runtime_log_info "Restore finished"
