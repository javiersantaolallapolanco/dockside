#!/bin/sh

set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)

pass() {
    printf '[PASS] %s\n' "$1"
}

fail() {
    printf '[FAIL] %s\n' "$1"
    exit 1
}

run() {
    name="$1"
    shift

    if "$@"; then
        pass "$name"
    else
        fail "$name"
    fi
}
