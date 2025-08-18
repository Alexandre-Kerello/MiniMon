#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="/opt/minimon"
BIN_LINK="/usr/local/bin/minimon"
CONFIG_DIR="/etc/minimon"

say() { echo -e "\033[1;32m[MiniMon]\033[0m $*"; }

read -rp "Would you also delete the configuration in $CONFIG_DIR/config.sh ? [y/N] " rm_cfg

# Delete symbolic link
if [ -L "$BIN_LINK" ]; then
  sudo rm -f "$BIN_LINK"
  say "Symbolic link $BIN_LINK deleted"
fi

# Delete installation directory
if [ -d "$INSTALL_DIR" ]; then
  sudo rm -rf "$INSTALL_DIR"
  say "Installation directory $INSTALL_DIR deleted"
fi

# Delete configuration
if [[ "$rm_cfg" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  sudo rm -rf "$CONFIG_DIR"
  say "Configuration $CONFIG_DIR deleted"
fi

# Delete minimon permission group
if getent group minimon >/dev/null; then
  sudo groupdel minimon || true
  say "Minimon group deleted"
fi

# Delete cron job
if crontab -l 2>/dev/null | grep -q "minimon"; then
  crontab -l | grep -v "minimon" | crontab -
  say "MiniMon cron job removed"
fi

say "MiniMon successfully uninstalled"
