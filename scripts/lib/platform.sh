#!/bin/sh

. "$DOCKSIDE_HOME/scripts/lib/compose.sh"
. "$DOCKSIDE_HOME/scripts/lib/state.sh"
. "$DOCKSIDE_HOME/scripts/lib/app.sh"

PLATFORM_FILE="$DOCKSIDE_INSTALL_DIR/platform.conf"

platform_each_stack() {

    require_file "$PLATFORM_FILE"

    while IFS= read -r stack
    do
        [ -n "$stack" ] || continue
        printf '%s\n' "$stack"
    done < "$PLATFORM_FILE"

}

platform_start() {

    config_load

    for stack in $(platform_each_stack)
    do
        compose_up "$stack"
        compose_wait "$stack"
    done

    state_platform_up

    info "Platform is UP"

}

platform_stop() {

    config_load

    app_stop_current

    stacks="$(platform_each_stack)"

    for stack in $(printf "%s\n" "$stacks" | awk '{a[NR]=$0} END{for(i=NR;i>=1;i--)print a[i]}')
    do
        compose_down "$stack"
    done

    state_platform_down

    info "Platform is DOWN"

}
