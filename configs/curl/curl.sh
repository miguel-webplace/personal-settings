#!/usr/bin/env bash
#
# installs curl

curl_config() {

    log "Installing curl"
    sudo apt install curl
    ok "Installed uv"
}
