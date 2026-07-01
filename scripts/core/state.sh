#!/bin/sh

. "$DOCKSIDE_HOME/scripts/core/config.sh"

STATE_FILE="$DOCKSIDE_INSTALL_DIR/state.env"

state_init() {

    config_init

    if [ ! -f "$STATE_FILE" ]; then
        cp "$DOCKSIDE_HOME/templates/state.env" \
           "$STATE_FILE"
    fi

}

state_load() {

    state_init

    . "$STATE_FILE"

}

state_save() {

cat > "$STATE_FILE" <<EOT
PLATFORM_STATUS=$PLATFORM_STATUS
CURRENT_APP=$CURRENT_APP
CURRENT_APP_STATUS=$CURRENT_APP_STATUS
LAST_START=$LAST_START
LAST_STOP=$LAST_STOP
EOT

}

state_platform_up() {

    state_load

    PLATFORM_STATUS=UP
    LAST_START=$(timestamp)

    state_save

}

state_platform_down() {

    state_load

    PLATFORM_STATUS=DOWN
    CURRENT_APP_STATUS=DOWN
    LAST_STOP=$(timestamp)

    state_save

}
