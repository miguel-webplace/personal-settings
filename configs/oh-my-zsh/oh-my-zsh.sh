#!/usr/bin/env bash
#
# configures zsh as default terminal and set .zshrc file

oh_my_zsh_config() {    
    log "Configuring zsh"

    chsh -s "$(which zsh)"

    cp "$SCRIPT_DIR_CFG/oh-my-zsh/.zshrc" "$HOME/.dotfiles/.zshrc"
    cd "$HOME"
    ln -s "$HOME/.dotfiles/.zshrc" "./.zshrc"
    cd "$SCRIPT_DIR"

    ok "zsh is now default terminal and .zshrc file is applied"
}
