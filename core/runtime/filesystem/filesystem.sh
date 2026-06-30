#!/bin/sh

runtime_fs_exists() {
    [ -e "$1" ]
}

runtime_fs_is_dir() {
    [ -d "$1" ]
}

runtime_fs_is_file() {
    [ -f "$1" ]
}

runtime_fs_mkdir() {
    mkdir -p "$1"
}

runtime_fs_remove() {
    rm -rf "$1"
}

runtime_fs_copy() {
    cp -R "$1" "$2"
}

runtime_fs_move() {
    mv "$1" "$2"
}
