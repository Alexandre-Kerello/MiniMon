#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="/opt/minimon"
BIN_LINK="/usr/local/bin/minimon"
CONFIG_DIR="/etc/minimon"

read -rp "Would you also delete the configuration in $CONFIG_DIR/config.sh ? [y/N]" rm_cfg
sudo rm -f "$BIN_LINK"
sudo rm -rf "$INSTALL_DIR"
if [[ "$rm_cfg" =~ ^([[yY][eE][sS]|[yY])$ ]]; then
  sudo rm -rf "$CONFIG_DIR"
fi
echo -e "\033[1;32m[MiniMon]\033[0m MiniMon successfully uninstalled"

