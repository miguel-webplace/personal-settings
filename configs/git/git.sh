#!/usr/bin/env bash
#
# Configures some gitconfig file

git_config() {

    log "Installing git"
    sudo apt install git
    
    log "Add gitconfig file to dotfiles and create a symlink"
    cp "$SCRIPT_DIR/configs/git/.gitconfig" "$HOME/.dotfiles/.gitconfig"
    cd "$HOME"
    ln -s "./.dotfiles/.gitconfig" "./.gitconfig"
    cd "$SCRIPT_DIR"
    
    ok "gitconfig file added"
}
