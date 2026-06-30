#!/bin/sh

catalog_list() {
    cat "$DOCKSIDE_ROOT/catalog/index/stacks.conf"
}

catalog_exists() {
    stack="$1"

    grep -qx "$stack" "$DOCKSIDE_ROOT/catalog/index/stacks.conf"
}
