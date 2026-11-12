#!/usr/bin/env bash

# Description: Makes desktop related configurations
# Target: Debian 13 (trixie) with GNOME
#
# Configurations : <
# - set profile picture
# - change window focus behavior to 'focus on hover'
# - raise window focused above unfocused windows
# - disable middle-click paste
# >

set -euo pipefail

# ------- import configs -------
. ./desktop.cfg


# ----- Profile picture -----
log "Setting profile picture"
cp -f "$FACE_SRC" "$HOME/.face.icon"
cp -f "$FACE_SRC" "$HOME/.face"
chmod 644 "$HOME/.face.icon" "$HOME/.face"


# ----- window focus and raise -----
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false
gsettings set org.gnome.desktop.wm.preferences auto-raise true


# ------ middle-click paste ------
gsettings set org.gnome.desktop.wm.preferences focus-mode 'sloppy'
