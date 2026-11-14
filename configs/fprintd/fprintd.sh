#!/usr/bin/env bash
#
# configures fingerprint

fprintd_config() {
    log "Configuring fprintd"

    sudo su miguel_andrade
    pam-auth-update --enable fprintd
    fprintd-enroll
    ok "fingerprint enrolled and enabled to unlock the pc"
}
