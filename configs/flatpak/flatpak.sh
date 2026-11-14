#!/usr/bin/env bash
#
# configures flatpak remote repository

flatpak_config() {
    log "Configuring flatpak"
    
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    ok "flatpak repo configured"
}
