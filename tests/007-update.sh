#!/bin/sh

. "$(dirname "$0")/common.sh"

grep -q '^compose_wait()' "$ROOT/scripts/compose/compose.sh"

pass update-compose-wait
