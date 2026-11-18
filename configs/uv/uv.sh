#!/usr/bin/env bash
#
# installs uv

uv_config() {

    log "Installing uv"
    SOURCE="https://astral.sh/uv/install.sh"
    curl -LsSf "$SOURCE" | sh
    ok "Installed uv"
}
