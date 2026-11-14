#!/usr/bin/env bash

# Description : install and configure packagesa and dotfiles automatically
# Target : Debian 13 (trixie)
#
# Packages : <
# - localsend
# - zen browser
# - zsh
# - oh-my-zsh
# - neovim        
# - openssh
# - zed editor
# - docker
# >


# Make sure to run as non-root user
# if [[ $EUID -eq 0 ]]; then
#     echo "Run this script as your normal user (it uses sudo when needed)." >&2
#     exit 1
# fi
# ---------------- >

set -euo pipefail

SCRIPT_DIR="$cd( "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd )"

source "$SCRIPT_DIR/configs/*/*.sh"
. "./packages.cfg"



# --------- Install packages from different managers ---------
for pkg in ${apt[@]}; do
    log "Installing $pkg"
    apt_install $pkg
done


for pkg in ${flatpak[@]}; do
    log "Installing $pkg"
    apt_install $pkg
done


for pkg in ${curl[@]}; do
    log "Installing $pkg"
    apt_install $pkg
done


# ------------- Configure packages ------------
for pkg in ${config_pkgs[@]}; do
    log "Configuring $pkg"
    $pkg
