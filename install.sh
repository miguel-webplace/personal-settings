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

set -euo pipefail

# Make sure to run as non-root user
if [[ $EUID -eq 0 ]]; then
  echo "Run this script as your normal user (it uses sudo when needed)." >&2
  exit 1
fi
# ---------------- >


# ----- import packages and variables -----
. ./packages.cfg
. ./helpers/helpers.cfg


# ----- APT cache clearing -----
log "Clearing apt cache"
sudo apt clean
sudo rm -rf /var/lib/apt/lists/*

log "Updating package index"
sudo apt update


# ------- apt installs -------
for pkg in apt; do
    log "Installing $pkg"
    apt_install() $pkg
done

# ----- create symlink to .gitconfig -----
cp "$DOTFILE/.gitconfig" "$HOME/$DOTFILE/.gitconfig"
ln -s "$HOME/$DOTFILE/.gitconfig" "$HOME/.gitconfig"


# ----- flatpak configure -----
log "Configuring flatpak"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


# ----- flatpak installs -----
for pkg in flatpak; do
    log "Installing $pkg"
    flatpak_install() $pkg
done


# ----- localsend configuration of device name -----
mkdir -p "$LOCALSEND_CONFIG"
python3 ./helpers/localsend.py "$LOCALSEND_CONFIG/shared_preferences.json" "$LOCALSEND_NAME"


# ----- check if oh-my-zsh already exists -----
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    oh-my-zsh="none"
    warn "oh-my-zsh already installed, will be skipped"


# ----- curl installs -----
for pkg in curl; do
    if [ pkg -ne "none"]; then
        log "Installing $pkg"
        curl_install() $pkg
    fi
done


# ----- configure .zshrc -----
log "Configuring .zshrc symlink"
cp "$DOTFILE/.zshrc "$HOME/$DOTFILE/.zshrc"
ln -s "$HOME/$DOTFILE/.zshrc" "$HOME/.zshrc"


# ----- configure oh-my-zsh plugin -----
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"


# ----- check if fingerprint-enroll was installed and asks for registration -----
log "Enabling fingerprint authentication in PAM"
sudo pam-auth-update --enable fprintd

if command -v fprintd-enroll >/dev/null 2>&1 && [[ -t 0 ]]; then
  read -rp "Enroll a fingerprint now? [y/N] " ENROLL || ENROLL=""
  if [[ "$ENROLL" =~ ^[Yy]$ ]]; then
    fprintd-enroll || warn "Enrollment failed (no reader?). Retry later with: fprintd-enroll"
  else
    warn "Skipped. Enroll later with: fprintd-enroll"
  fi
fi


# ----- copy the zed config and create symlink -----
ZED_DOTFILE="$DOTFILE/$ZED"
ZED_CONFIG="$HOME/.config/zed"

cp "$ZED_DOTFILE" "$HOME/$ZED_DOTFILE"
ln -s "$HOME/$ZED_DOTFILE" "$HOME/.config/$ZED"


# -----install docker -----
log "Installing Docker"
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sudo sh
else
  warn "Docker already installed, skipping"
fi
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"



# ------- desktop configs -------
sh "$DESKTOP_INSTALL"


# ---------- done ----------
log "All done!"
warn "Log out and back in so the zsh shell and docker group changes take effect."
