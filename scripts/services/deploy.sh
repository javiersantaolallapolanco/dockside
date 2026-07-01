#!/bin/sh

. "$DOCKSIDE_HOME/scripts/services/update.sh"
. "$DOCKSIDE_HOME/scripts/services/doctor.sh"
. "$DOCKSIDE_HOME/scripts/services/status.sh"

deploy_run() {
  app="${1:-}"

  [ -n "$app" ] || die "Usage: dockside deploy <app>"

  update_run "$app"
  doctor_run
  status_show
}
