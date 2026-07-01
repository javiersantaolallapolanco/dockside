#!/bin/sh

. "$(dirname "$0")/common.sh"

run init \
    test -f /share/CACHEDEV1_DATA/docker/dockside/dockside.env
