#!/usr/bin/env bash
#
# installs balena etcher

curl_config() {

    log "Installing curl"
    BALENA_ETCHER_DOWNLOAD="https://github.com/balena-io/etcher/releases/download/v2.1.9/balena-etcher_2.1.9_amd64.deb"
    wget -P "$SCRIPT_DIR/configs/balena-etcher" "$BALENA_ETCHER_DOWNLOAD"
    sudo apt install \
    "$SCRIPT_DIR/configs/balena-etcher/balena-etcher_2.1.9_amd64.deb etcher"
    ok "Installed balena etcher"
}
