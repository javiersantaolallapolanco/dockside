#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/update.sh"
. "$DOCKSIDE_HOME/scripts/lib/doctor.sh"
. "$DOCKSIDE_HOME/scripts/lib/status.sh"

deploy_run() {
  app="${1:-}"

  [ -n "$app" ] || die "Usage: dockside deploy <app>"

  update_run "$app"
  doctor_run
  status_show
}
