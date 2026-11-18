#!/usr/bin/env bash

# Description : install and configure packages and dotfiles automatically
# Target : Debian 13 (trixie)
#
# See all of them in 'packages.txt'

# Make sure to run as non-root user
# if [[ $EUID -eq 0 ]]; then
#     echo "Run this script as your normal user (it uses sudo when needed)." >&2
#     exit 1
# fi
# ---------------- >

set -euo pipefail

. "$SCRIPT_DIR/helpers.cfg"

update_pckgs_list

PACKAGES=()
while IFS= read -r line; do
  PACKAGES+=("$line")
done < "$SCRIPT_DIR/packages.txt"

for pack in ${PACKAGES[@]}; do
    source "$SCRIPT_DIR/configs/$pack/$pack.sh"
    ${pack}_config
done
