#!/usr/bin/env bash
# desktop_install.sh
# Installs: LocalSend, Zen Browser, zsh, oh-my-zsh, neovim,
#           openssh, Zed editor, Docker
# Target: Debian 13 (trixie) — apt. dnf/pacman kept as fallbacks.

set -euo pipefail

# ---------- helpers ----------
log()  { printf '\n\033[1;34m[+] %s\033[0m\n' "$*"; }
warn() { printf '\n\033[1;33m[!] %s\033[0m\n' "$*"; }

if [[ $EUID -eq 0 ]]; then
  echo "Run this script as your normal user (it uses sudo when needed)." >&2
  exit 1
fi

if command -v apt-get >/dev/null 2>&1; then
  PM=apt
elif command -v dnf >/dev/null 2>&1; then
  PM=dnf
elif command -v pacman >/dev/null 2>&1; then
  PM=pacman
else
  echo "Unsupported package manager (need apt, dnf or pacman)." >&2
  exit 1
fi

pkg_install() {
  case "$PM" in
    apt)    sudo apt-get install -y "$@" ;;
    dnf)    sudo dnf install -y "$@" ;;
    pacman) sudo pacman -S --needed --noconfirm "$@" ;;
  esac
}

# ---------- base ----------
log "Updating package index"
case "$PM" in
  apt)    sudo apt-get update ;;
  dnf)    sudo dnf makecache ;;
  pacman) sudo pacman -Sy ;;
esac

pkg_install curl git

# ---------- Flatpak (for LocalSend + Zen Browser) ----------
log "Installing Flatpak"
pkg_install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# ---------- LocalSend ----------
log "Installing LocalSend"
flatpak install -y flathub app.localsend.localsend_app

# Config: set the device name (alias) shown to other devices
LOCALSEND_NAME="minuz-notebook"
pkg_install python3
for dir in \
  "$HOME/.var/app/app.localsend.localsend_app/data/org.localsend.localsend_app" \
  "$HOME/.var/app/app.localsend.localsend_app/data/app.localsend.localsend_app"; do
  mkdir -p "$dir"
  python3 - "$dir/shared_preferences.json" "$LOCALSEND_NAME" <<'PY'
import json, sys
path, name = sys.argv[1], sys.argv[2]
try:
    with open(path) as f:
        data = json.load(f)
except (FileNotFoundError, json.JSONDecodeError):
    data = {}
data["flutter.ls_alias"] = name
with open(path, "w") as f:
    json.dump(data, f, indent=4)
PY
done

# ---------- Zen Browser ----------
log "Installing Zen Browser"
flatpak install -y flathub app.zen_browser.zen

# ---------- zsh ----------
log "Installing zsh"
pkg_install zsh

# ---------- oh-my-zsh ----------
log "Installing oh-my-zsh"
# TODO: configuration (to be provided)
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  warn "oh-my-zsh already installed, skipping"
fi

log "Configuring oh-my-zsh"
ZSHRC="$HOME/.zshrc"
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# zsh-syntax-highlighting is not bundled with oh-my-zsh, so clone it
if [[ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]]; then
  git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git \
    "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
fi

[[ -f "$ZSHRC" ]] || cp "$HOME/.oh-my-zsh/templates/zshrc.zsh-template" "$ZSHRC"

# Theme: bira
if grep -q '^ZSH_THEME=' "$ZSHRC"; then
  sed -i 's|^ZSH_THEME=.*|ZSH_THEME="bira"|' "$ZSHRC"
else
  echo 'ZSH_THEME="bira"' >> "$ZSHRC"
fi

# Plugins (zsh-syntax-highlighting goes last)
if grep -qE '^plugins=' "$ZSHRC"; then
  perl -0pi -e 's/^plugins=\([^)]*\)/plugins=(git zsh-interactive-cd zsh-syntax-highlighting)/m' "$ZSHRC"
else
  echo 'plugins=(git zsh-interactive-cd zsh-syntax-highlighting)' >> "$ZSHRC"
fi

# Alias for Zed
ZED_ALIAS="alias zed='/home/miguel_andrade/.local/bin/zed'"
grep -qxF "$ZED_ALIAS" "$ZSHRC" || echo "$ZED_ALIAS" >> "$ZSHRC"

log "Setting zsh as default shell"
ZSH_PATH="$(command -v zsh)"
if [[ "${SHELL:-}" != "$ZSH_PATH" ]]; then
  chsh -s "$ZSH_PATH" || warn "Could not change shell; run: chsh -s $ZSH_PATH"
fi

# ---------- neovim ----------
log "Installing neovim"
pkg_install neovim

# ---------- openssh ----------
log "Installing openssh"
case "$PM" in
  apt)    pkg_install openssh-client openssh-server ;;
  dnf)    pkg_install openssh-clients openssh-server ;;
  pacman) pkg_install openssh ;;
esac

# ---------- Fingerprint unlock (fprintd) ----------
log "Installing fingerprint support (fprintd, libpam-fprintd)"
case "$PM" in
  apt)    pkg_install fprintd libpam-fprintd ;;
  dnf)    pkg_install fprintd fprintd-pam ;;
  pacman) pkg_install fprintd ;;
esac

if [[ "$PM" == "apt" ]]; then
  log "Enabling fingerprint authentication in PAM"
  sudo pam-auth-update --enable fprintd
fi

if command -v fprintd-enroll >/dev/null 2>&1 && [[ -t 0 ]]; then
  read -rp "Enroll a fingerprint now? [y/N] " ENROLL || ENROLL=""
  if [[ "$ENROLL" =~ ^[Yy]$ ]]; then
    fprintd-enroll || warn "Enrollment failed (no reader?). Retry later with: fprintd-enroll"
  else
    warn "Skipped. Enroll later with: fprintd-enroll"
  fi
fi

# ---------- Zed editor ----------
log "Installing Zed editor"
curl -f https://zed.dev/install.sh | sh

# Config: copy the "zed" folder that sits next to this script to ~/.config/zed
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZED_CONFIG_SRC="$SCRIPT_DIR/zed"          # <- change if your folder has another name
ZED_CONFIG_DEST="$HOME/.config/zed"

if [[ -d "$ZED_CONFIG_SRC" ]]; then
  log "Copying Zed config to $ZED_CONFIG_DEST"
  if [[ -d "$ZED_CONFIG_DEST" ]]; then
    BACKUP="$ZED_CONFIG_DEST.bak.$(date +%Y%m%d%H%M%S)"
    warn "Existing Zed config found, backing up to $BACKUP"
    mv "$ZED_CONFIG_DEST" "$BACKUP"
  fi
  mkdir -p "$(dirname "$ZED_CONFIG_DEST")"
  cp -r "$ZED_CONFIG_SRC" "$ZED_CONFIG_DEST"
else
  warn "Zed config folder not found at $ZED_CONFIG_SRC, skipping"
fi

# ---------- Docker ----------
log "Installing Docker"
if ! command -v docker >/dev/null 2>&1; then
  case "$PM" in
    pacman)
      pkg_install docker docker-compose
      ;;
    *)
      curl -fsSL https://get.docker.com | sudo sh
      ;;
  esac
else
  warn "Docker already installed, skipping"
fi
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

# ---------- Profile picture ----------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FACE_SRC="$SCRIPT_DIR/.face"              # <- file sitting next to this script

if [[ -f "$FACE_SRC" ]]; then
  log "Setting profile picture"
  cp -f "$FACE_SRC" "$HOME/.face.icon"
  cp -f "$FACE_SRC" "$HOME/.face"          # also used by some desktops (e.g. GNOME)
  chmod 644 "$HOME/.face.icon" "$HOME/.face"
else
  warn "Profile picture not found at $FACE_SRC, skipping"
fi

# ---------- done ----------
log "All done!"
warn "Log out and back in so the zsh shell and docker group changes take effect."
