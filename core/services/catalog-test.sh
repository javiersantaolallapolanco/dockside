#!/bin/sh
set -eu

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DOCKSIDE_ROOT="$(CDPATH= cd -- "$SELF_DIR/../.." && pwd)"
export DOCKSIDE_ROOT

. "$SELF_DIR/catalog-service.sh"

catalog_exists traefik
catalog_exists supabase
catalog_exists github-runner

echo "Catalog service OK"
