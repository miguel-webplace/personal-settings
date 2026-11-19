#!/usr/bin/env bash
#
# creates ssh key into .dotfiles folder,
# create a symlink to expected location and
# add the key to the ssh agent

github_ssh_config() {    
    log "Configuring github ssh key"

    SSH_EMAIL="minuz.code@gmail.com"
    read -rp "Digite sua frase-senha:" SSH_PASSPHRASE
    GITHUB_KEY="github_key"
    SSH_FILEPATH="$HOME/.dotfiles/$GITHUB_KEY"
    
    ssh-keygen -t ed25519 -C "$SSH_EMAIL" \
    -N "$SSH_PASSPHRASE" -f "$SSH_FILEPATH"

    cd "$HOME/.ssh"
    ln -s "../.dotfiles/$GITHUB_KEY" "$GITHUB_KEY"
    cd "$SCRIPT_DIR"

    eval "$(ssh-agent -s)"
    ssh-add -K "$HOME/.ssh/$GITHUB_KEY"

    ok "ssh key configured"
}
