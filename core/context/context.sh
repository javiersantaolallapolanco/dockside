#!/bin/sh

SELF_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
ROOT_DIR="$(CDPATH= cd -- "$SELF_DIR/../.." && pwd)"

DOCKSIDE_ROOT="$ROOT_DIR"

DOCKSIDE_PLATFORM_DIR="$ROOT_DIR/platform"

DOCKSIDE_CONFIG_DIR="$ROOT_DIR/config"

DOCKSIDE_TEMPLATE_DIR="$ROOT_DIR/templates"

DOCKSIDE_ADAPTERS_DIR="$ROOT_DIR/adapters"

DOCKSIDE_DOCS_DIR="$ROOT_DIR/docs"
