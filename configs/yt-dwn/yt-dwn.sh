#!/usr/bin/env bash
#
# copies youtube downloader script to tools folder

yt_dwn_config() {

    log "Configurin yt-dwn"

    TOOLS_PATH="$HOME/tools/tools"
    mkdir -p "$TOOLS_PATH"
    cp "$SCRIPT_DIR/configs/yt-dwn/yt-down" "$TOOLS_PATH/yt-down"

    echo "alias ytdwn='$HOME/tools/tools/yt-down/yt-down.py'" >> "$HOME/.zshrc"

    cd "$TOOLS_PATH/.."
    ln -s "tools/yt-down/yt-down.py" "yt-down.py"
    cd "$SCRIPT_DIR"
}
