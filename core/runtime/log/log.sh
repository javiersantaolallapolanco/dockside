#!/bin/sh

runtime_log() {
    level="$1"
    shift

    printf '[%s] %s\n' "$level" "$*"
}

runtime_log_info() {
    runtime_log INFO "$@"
}

runtime_log_warn() {
    runtime_log WARN "$@" >&2
}

runtime_log_error() {
    runtime_log ERROR "$@" >&2
}

runtime_log_fatal() {
    runtime_log ERROR "$@" >&2
    exit 1
}
