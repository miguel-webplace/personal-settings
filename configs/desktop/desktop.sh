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

    ok "All settings were setted"
}
