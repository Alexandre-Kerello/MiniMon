#!/usr/bin/env bash
set -uo pipefail

APP_NAME="MiniMon"
INSTALL_DIR="/opt/minimon"
CONFIG_DIR="/etc/minimon"

c_bold="\033[1m"; c_red="\033[31m"; c_yellow="\033[33m"; c_green="\033[32m"; c_reset="\033[0m"

log()   { echo -e "${c_green}[${APP_NAME}]${c_reset} $*"; }
warn()  { echo -e "${c_yellow}[${APP_NAME}] WARN${c_reset} $*"; }
error() { echo -e "${c_red}[${APP_NAME}] ERROR${c_reset} $*" >&2; }

load_config() {
  if [ -f "$CONFIG_DIR/config.sh" ]; then
    source "$CONFIG_DIR/config.sh"
  else
    error "No configuration file found (searched: $CONFIG_FILE/config.sh"
    exit 1
  fi
}

bool() {
  case "$1" in 
    true|TRUE|1|yes|y)
      return 0;;
    *)
      return 1;;
  esac;
}

send_alert() {
  local msg="$1"
  if bool "${ENABLE_EMAIL:-false}" && [ -x "$INSTALL_DIR/alerts/email.sh" ]; then
    "$INSTALL_DIR/alerts/email.sh" "$msg" || warn "Email failed"
  fi
  if bool "${ENABLE_TELEGRAM:-false}" && [ -x "$INSTALL_DIR/alerts/telegram.sh" ]; then
    "$INSTALL_DIR/alerts/telegram.sh" "$msg" || warn "Telegram failed"
  fi
}
