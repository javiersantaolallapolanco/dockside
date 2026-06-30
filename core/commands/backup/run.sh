#!/bin/sh
set -eu

runtime_load log
runtime_load filesystem

. "$DOCKSIDE_ROOT/core/services/backup/backup-service.sh"

BACKUP_STACK=""
BACKUP_DIR=""

backup_usage() {
    cat <<'USAGE'
Usage:
  dockside backup
  dockside backup --stack <name>
  dockside backup --dir <path>

Options:
  --stack NAME    Backup only one catalog stack
  --dir PATH      Backup destination directory
USAGE
}

while [ "$#" -gt 0 ]
do
    case "$1" in
        --stack)
            [ "$#" -ge 2 ] || runtime_log_fatal "--stack requires a value"
            BACKUP_STACK="$2"
            shift 2
            ;;
        --dir)
            [ "$#" -ge 2 ] || runtime_log_fatal "--dir requires a value"
            BACKUP_DIR="$2"
            shift 2
            ;;
        --help|-h)
            backup_usage
            exit 0
            ;;
        *)
            runtime_log_fatal "Unknown backup option: $1"
            ;;
    esac
done

if [ -n "$BACKUP_DIR" ]; then
    DOCKSIDE_BACKUP_DIR="$BACKUP_DIR"
    export DOCKSIDE_BACKUP_DIR
fi

STAMP="$(backup_timestamp)"

printf "\n"
printf "Dockside Backup\n"
printf "%s\n\n" "============================"
printf "%-18s %s\n" "Timestamp" "$STAMP"
printf "%-18s %s\n" "Destination" "$(backup_root_dir)"
if [ -n "$BACKUP_STACK" ]; then
    printf "%-18s %s\n" "Stack" "$BACKUP_STACK"
else
    printf "%-18s %s\n" "Stack" "all"
fi
printf "\n"

backup_all "$BACKUP_STACK" "$STAMP"

printf "\n"
runtime_log_info "Backup finished"
