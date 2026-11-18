#!/usr/bin/env bash
#
# Installs openssh server and client

openssh_config() {

    log "Installing openssh"
    sudo apt install openssh-client openssh-server
    
    ok "Installed openssh"
}
