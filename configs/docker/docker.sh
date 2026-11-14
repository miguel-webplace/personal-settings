#!/usr/bin/env bash
#
# configures docker for current user


docker_config() {
    log "configuring docker"
    
    sudo systemctl enable --now docker
    sudo usermod -aG docker "$USER"
    sudo -k
    ok "docker enabled to current user"
}
