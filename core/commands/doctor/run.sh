#!/bin/sh
set -eu

. "$DOCKSIDE_ROOT/core/services/doctor/doctor.sh"

doctor_run "$@"
