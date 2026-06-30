#!/bin/sh

runtime_log_info() {
    printf '%s\n' "[INFO] $*"
}

runtime_log_warn() {
    printf '%s\n' "[WARN] $*" >&2
}

runtime_log_error() {
    printf '%s\n' "[ERROR] $*" >&2
}
