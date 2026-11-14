#!/usr/bin/env bash
#
# configures machine name to other devices on the network

localsend_config() {
    log "configuring localsend"

    SCRIPT_DIR_CFG="$SCRIPT_DIR/configs"
    
    LOCALSEND_CONFIG=\
    "var/app/org.localsend.localsend_app/data/shared_preferences.json"
    LOCALSEND_NAME=\
    "minuz-notebook"

    mkdir -p "$LOCALSEND_CONFIG"
    python3 "$SCRIPT_DIR_CFG/localsend/.localsend.py" \ 
        "$LOCALSEND_CONFIG" "$LOCALSEND_NAME"

    ok "hostname changed to netework"
}
