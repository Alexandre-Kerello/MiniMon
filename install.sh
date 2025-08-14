#!/usr/bin/env bash
set -e

echo "=== MiniMon installation ==="

# Check required dependencies
REQUIERED_CMDS=(bash free df systemctl msmtp cron)
for cmd in "${REQUIERED_CMDS[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "▶️Missing dependencies: $cmd"
    MISSING=true
  fi
done

if [ "$MISSING" = true ]; then
  echo "Install missing dependencies (sudo apt install ...)"
  exit 1
fi

# Installation directories
INSTALL_DIR="/opt/minimon"
CONFIG_DIR="/etc/minimon"

# Copy file to /opt/minimon
echo "▶️Creating $INSTALL_DIR directory"
sudo mkdir -p "$INSTALL_DIR"
sudo cp -r . "$INSTALL_DIR"

# Move config.sh file to /etc/minimon
echo "▶️Installing configuration in $CONFIG_DIR"
sudo mkdir -p "$CONFIG_DIR"
if [ -f "$INSTALL_DIR/config.sh" ]; then
  sudo mv "$INSTALL_DIR/config.sh" "$CONFIG_DIR/config.sh"
else
  echo "⚠️ Missing config.sh file, creating a default file"
  echo '# MiniMon default config' | sudo tee "$CONFIG_DIR/config.sh" > /dev/null
fi
sudo chmod 640 "$CONFIG_DIR/config.sh"
sudo chown root:root "$CONFIG_DIR/config.sh"

# Permissions
if [ -f "$INSTALL_DIR/minimon.sh" ]; then
  sudo chmod +x "$INSTALL_DIR/minimon.sh"
fi

if [ -d "$INSTALL_DIR/alerts" ]; then
  sudo chmod +x "$INSTALL_DIR/alerts/"*.sh 2>/dev/null || true
fi

if [ -d "$INSTALL_DIR/modules" ]; then
  sudo chmod +x "$INSTALL_DIR/modules/"*.sh 2>/dev/null || true
fi

# Symbolic link
echo "▶️Creatiing a symbolic link to /usr/local/bin/minimon"
sudo ln -sf "$INSTALL_DIR/minimon.sh" /usr/local/bin/minimon

# Optional cron job
read -p "Would you like to enable automatic execution (cron @hourly)? [y/N]" install_cron
if [[ "$install_cron" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  (crontab -l 2>/dev/null; echo "@hourly /usr/bin/local/minimon >> ~/minimon.log 2>&1") | crontab -
  echo "▶️Cron job added: MiniMon executed every hour"
else
  echo "▶️Cron job nott installed (You can add it manually via crontab -e)"
fi

echo "✅ MiniMon successfully installed !"
echo "You can use MiniMon tool using command: minimon"
echo "Configuration: $CONFIG_DIR/config.sh"
