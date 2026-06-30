#!/bin/sh

assert_file_exists() {
    if [ ! -f "$1" ]; then
        printf '%s\n' "ERROR: file not found: $1" >&2
        exit 1
    fi
}

assert_directory_exists() {
    if [ ! -d "$1" ]; then
        printf '%s\n' "ERROR: directory not found: $1" >&2
        exit 1
    fi
}

assert_command_exists() {
    if ! command -v "$1" >/dev/null 2>&1; then
        printf '%s\n' "ERROR: command not found: $1" >&2
        exit 1
    fi
}

assert_file_readable() {
    if [ ! -r "$1" ]; then
        printf '%s\n' "ERROR: file not readable: $1" >&2
        exit 1
    fi
}
