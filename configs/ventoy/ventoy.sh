#!/usr/bin/env bash
#
# copies the compressed file and the script to tools folder

ventoy_config() {

    log "Create tools folder (if not exists) and coping ventoy files"
    TOOLS_PATH="$HOME/tools/tools/"
    mkdir -p $TOOLS_PATH

    cp "$SCRIPT_DIR/configs/ventoy/ventoy-usb.sh_" "$TOOLS_PATH/ventoy-usb.sh"
    cp "$SCRIPT_DIR/configs/ventoy/ventoy.tar.gz" "$TOOLS_PATH/ventoy.tar.gz"

    cd "$TOOLS_PATH/.."
    ln -s "tools/ventoy/ventoy-usb.sh" "./ventoy-usb.sh"
    cd "$SCRIPT_DIR"
}
