#!/usr/bin/env bash
#
# configures docker for current user


docker_config() {

    log "Installing docker"
    SOURCE=docker="https://get.docker.com"
    curl -fsSL "$SOURCE" | sudo sh
    
    log "Configuring docker"
    sudo systemctl enable --now docker
    sudo usermod -aG docker "$USER"
    sudo -k
    ok "Docker enabled to current user"
}
