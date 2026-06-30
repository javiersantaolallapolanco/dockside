#!/bin/sh

path_join() {
    left="$1"
    right="$2"
    printf '%s/%s\n' "${left%/}" "${right#/}"
}

path_basename() {
    basename "$1"
}
