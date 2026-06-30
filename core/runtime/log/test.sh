#!/bin/sh
set -eu

. "$(dirname "$0")/log.sh"

runtime_log_info "Log runtime OK"
runtime_log_warn "Warning test"
runtime_log_error "Error test"
