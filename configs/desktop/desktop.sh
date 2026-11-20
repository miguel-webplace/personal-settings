#!/usr/bin/env bash
#
# Configures some desktop preferences

desktop_config() {
    
    log "Setting profile picture"
    
    cp -f "$SCRIPT_DIR/configs/desktop/.face" "$HOME/.face"
    cp -f "$SCRIPT_DIR/configs/desktop/.face" "$HOME/.face.icon"
    chmod 644 "$HOME/.face.icon" "$HOME/.face"
    
    log "Disable middle-click paste"
    gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false

    log "Raise window when focused"
    gsettings set org.gnome.desktop.wm.preferences auto-raise true
    
    log "Focus on window when mouse hovers"
    gsettings set org.gnome.desktop.wm.preferences focus-mode 'sloppy'

    log "Include maximize and minimize buttons on opened windows"
    gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'

    log "Set cursor theme to bibata amber"
    CURSOR_FOLDER="/usr/share/icons/BibaraAmber"
    mkdir -p "$CURSOR_FOLDER"
    tar -xf "$SCRIPT_DIR/configs/desktop/bibata-amber-cursor.tar.xz" -C "$CURSOR_FOLDER"
    gsettings set org.gnome.desktop.interface cursor-theme 'BibataAmber'

    ok "All settings were setted"
}
