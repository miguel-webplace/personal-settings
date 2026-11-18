#!/usr/bin/env bash
#
# downloads and installs artcraft launchcer


artcraft_config() {

    ARTCRAFT_PATH="$HOME/downloads/zips/artcraft-launcher.deb"
    
    log "Downloading artcraft launcher..."
    wget -O "$ARTCRAFT_PATH" \
    "https://github.com/storytold/craft-launcher/releases/download/v0.19.2/artcraft-launcher-0.19.2-linux-x86_64.deb"
    log "Download done" 

    log "Installing artcraft laucher..."
    sudo apt install "$ARTCRAFT_PATH"
    ok "Installation completed"
}
