#!/usr/bin/env bash
#
# copies the compressed file and the script to tools folder

ventoy_config() {

    VENTOY_PATH_SRC="$SCRIPT_DIR/configs/ventoy/"
    VENTOY_PATH_DEST="$HOME/tools/ventoy"
    log "Create tools folder (if not exists) and coping ventoy files"
    mkdir -p $VENTOY_PATH
    cp "$VENTOY_PATH_SRC/ventoy-usb.sh_" "$VENTOY_PATH_DEST/ventoy-usb.sh"
    cp "$VENTOY_PATH_SRC/ventoy.tar.gz" "$VENTOY_PATH_DEST/ventoy.tar.gz"
}
