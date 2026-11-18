#!/usr/bin/env bash
#
# Installs zen browser

zen_browser_config() {

    log "Installing zen browser"
    flatpak install -y app.zen_browser.zen    
    ok "Installed ze browser"
}
