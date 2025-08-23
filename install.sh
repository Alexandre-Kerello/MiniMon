#!/usr/bin/env bash
set -euo pipefail

APP_NAME="MiniMon"
INSTALL_DIR="/opt/minimon"
BIN_LINK="/usr/local/bin/minimon"
CONFIG_DIR="/etc/minimon"
LOG_FILE="/var/log/minimon.log"
DEFAULT_CONFIG_SRC="./config.example.sh"

# Colors
c_green="\033[1;32m"
c_red="\033[1;31m"
c_yellow="\033[1;33m"
c_reset="\033[0m"

say()  { echo -e "${c_green}[${APP_NAME}]${c_reset} $*"; }
warn() { echo -e "${c_yellow}[${APP_NAME}] WARN${c_reset} $*"; }
err()  { echo -e "${c_red}[${APP_NAME}] ERROR${c_reset} $*" >&2; }

say "$APP_NAME installation..."

# Check required dependencies
REQUIERED_CMDS=(bash free df top curl msmtp cron)
MISSING=()
for cmd in "${REQUIERED_CMDS[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    warn "Missing dependencies: $cmd"
    MISSING+=("$cmd")
  fi
done

if ((${#MISSING[@]})); then
  err "Install missing dependencies (sudo apt install ${MISSING[*]})"
  exit 1
fi

# Copy file to /opt/minimon
say "Creating $INSTALL_DIR directory"
sudo mkdir -p "$INSTALL_DIR"
sudo rsync -a --delete --exclude ".git" --exclude ".github" ./ "$INSTALL_DIR/"

# Scripts permissions
sudo chmod +x "$INSTALL_DIR/minimon.sh" || true
[ -d "$INSTALL_DIR/alerts" ]  && sudo chmod +x "$INSTALL_DIR/alerts"/*.sh 2>/dev/null || true
[ -d "$INSTALL_DIR/modules" ] && sudo chmod +x "$INSTALL_DIR/modules"/*.sh 2>/dev/null || true
[ -f "$INSTALL_DIR/report.sh" ] && sudo chmod +x "$INSTALL_DIR/report.sh" || true
[ -f "$INSTALL_DIR/lib/common.sh" ] && sudo chmod +x "$INSTALL_DIR/lib/common.sh" || true

# Symbolic link
say "Creating a symbolic link to /usr/local/bin/minimon"
sudo ln -sf "$INSTALL_DIR/minimon.sh" "$BIN_LINK"

# Move config.sh file to /etc/minimon
say "Installling configuration file in $CONFIG_DIR"
sudo mkdir -p "$CONFIG_DIR"
if [ -f "$DEFAULT_CONFIG_SRC" ]; then
  say "Installing a default config file in $CONFIG_DIR/config.sh"
  sudo cp "$DEFAULT_CONFIG_SRC" "$CONFIG_DIR/config.sh"
else
  say "Creating a a default config file"
  sudo tee "$CONFIG_DIR/config.sh" >/dev/null <<'CFG'
# === MiniMon configuration file ===
# Email alert via SMTP (optional)
ENABLE_EMAIL=false
SMTP_SERVER="smtp.example.com"
SMTP_PORT=587
SMTP_TLS=true           # true|false
SMTP_USER=""
SMTP_PASS=""
EMAIL_FROM="minimon@localhost"
EMAIL_TO=""

# Telegram alert (optional)
ENABLE_TELEGRAM=false
TELEGRAM_TOKEN=""
TELEGRAM_CHAT_ID=""

# Alerts threshold (%)
CPU_ALERT=85            # % CPU used
RAM_ALERT=90            # % RAM used
DISK_ALERT=90           # % disk used on DISK_PATH
DISK_PATH="/"          # mount point to watch

# Services to monitor (systemd)
SERVICES=("ssh" "cron")

# Miscellaneous
LOG_FILE="/var/log/minimon.log"   # usefull if using cron
REPORT_DIR="/home/$USER"          # don't forget to create the directory
CFG
fi

# Create minimon user group
if ! getent group minimon >/dev/null; then
  say "Creating minimon user group"
  sudo groupadd minimon
fi

# Attribute permissions
sudo chgrp minimon "$CONFIG_DIR/config.sh"
sudo chmod 640 "$CONFIG_DIR/config.sh"

# Add current user to minimon group
say "Adding user $USER to minimon group"
sudo usermod -aG minimon "$USER"

# Optional cron job
read -rp "Would you like to enable automatic execution (cron @hourly)? [y/N] " install_cron
if [[ "$install_cron" =~ ^([yY][eE][sS]|[yY])$ ]]; then
  (crontab -l 2>/dev/null; echo "@hourly $BIN_LINK --report txt >> $LOG_FILE 2>&1") | crontab -
  say "Cron job added: MiniMon executed every hour"
else
  say "Cron job not installed (You can add it manually via crontab -e)"
fi

say "$APP_NAME successfully installed !"
say "Log out / log back in to activate the minimon group rights"
say "You can use MiniMon tool using command: minimon"
say "Minimon configuration: $CONFIG_DIR/config.sh"
