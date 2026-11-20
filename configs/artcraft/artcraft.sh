#!/usr/bin/env bash
#
# downloads and installs artcraft launchcer


artcraft_config() {

    log "Downloading artcraft launcher"
    ARTCRAFT_PATH="$SCRIPT_DIR/configs/artcraft/artcraft-launcher.deb"
    ARTCRAFT_DOWNLOAD="https://github.com/storytold/craft-launcher/releases/download/v0.19.2/artcraft-launcher-0.19.2-linux-x86_64.deb"
    wget -P "$SCRIPT_DIR/configs/artcraft/" $ARTCRAFT_DOWNLOAD

    log "Installing artcraft laucher..."
    sudo apt install "$ARTCRAFT_PATH"
    ok "Installation completed"
}
