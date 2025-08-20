#!/usr/bin/env bash
set -euo pipefail

source "/opt/minimon/lib/common.sh"
load_config

if [ -z "${TELEGRAM_TOKEN:-}" ] || [ -z "${TELEGRAM_CHAT_ID:-}" ]; then
  error "TELEGRAM_TOKEN/CHAT_ID not configured"
  exit 1
fi

MSG="$1"
URL="https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage"

curl -s -X POST "$URL" -d chat_id="$TELEGRAM_CHAT_ID" -d text="$MSG" > /dev/null || {
  error "Telegram sending failed"
  exit 1
}
