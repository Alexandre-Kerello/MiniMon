#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="/opt/minimon"
BIN_LINK="/usr/local/bin/minimon"
CONFIG_DIR="/etc/minimon"

say() { echo -e "\033[1;32m[MiniMon]\033[0m $*" }

read -rp "Would you also delete the configuration in $CONFIG_DIR/config.sh ? [y/N]" rm_cfg

# Delete symbolic link
if [ -L "/usr/local/bin/minimon" ]; then
  sudo rm -f "$BIN_LINK"
  say "Symbolic link /usr/local/bin/minimon deleted"
fi

# Delete installation directory
if [ -d "$INSTALL_DIR" ]; then
  sudo rm -rf "$INSTALL_DIR"
  say "Installation directory deleted"
fi

# Delete configuration
if [[ "$rm_cfg" =~ ^([[yY][eE][sS]|[yY])$ ]]; then
  sudo rm -rf "$CONFIG_DIR"
  say "Configuration /etc/minimon deleted"
fi

# Delete minimon permission group
if getent group minimon >/dev/null; then
  if [ "$(grep -c "minimon" /etc/group)" -gt 0]; then
    sudo groupdel minimon || true
    say "Minimon group deleted"
  fi
fi

# Delete cron job
crontab -l 2>/dev/null | grep -v "minimon" | crontab - || true

say "MiniMon successfully uninstalled"
