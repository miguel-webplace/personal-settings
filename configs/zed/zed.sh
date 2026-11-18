#!/usr/bin/env bash
#
# Configures zed settings

zed_config() {
    
    log "Installing zed"
    SOURCE="https://zed.dev/install.sh"
    curl -fsSL "$SOURCE" | sh

    log "Setting zed settings to dotfiles folder and create a symlink"
    cp -R "$SCRIPT_DIR/configs/zed/zed_cfgs" "$HOME/.dotfiles/zed"
    cd "$HOME/.config"
    ln -s "../.dotfiles/zed" "./zed"
    cd "$SCRIPT_DIR"
    
    ok "Zed configs folder added"
}
