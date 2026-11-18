#!/usr/bin/env bash
#
# configures fingerprint

fprintd_config() {

    log "Installing fprintd and libpam-fprintd"
    sudo apt install fprintd libpam-fprintd
    
    log "Configuring fprintd"
    sudo su miguel_andrade
    pam-auth-update --enable fprintd
    fprintd-enroll
    ok "Fingerprint enrolled and enabled to unlock the pc"
}
