#!/usr/bin/env bash
set -euo pipefail

source "/opt/minimon/lib/common.sh"
load_config

SUBJECT="⚠️ MiniMon Alert"
BODY="$1"

TLS_FLAG="--tls=off"
if bool "${SMTP_TLS:-true}"; then
  TLS_FLAG="--tls=on"
fi

{
  echo "From: ${EMAIL_FROM:-minimon@localhost}"
  echo "To: ${EMAIL_TO}"
  echo "Subject: ${SUBJECT}"
  echo
  echi "$BODY"
} | msmtp \
  --host="${SMTP_SERVER}" \
  --port="${SMTP_PORT}" \
  --auth=on \
  --user="${SMTP_USER}" \
  --passwordeval="echo ${SMTP_PASS}" \
  ${TLS_FLAG} \
  "${EMAIL_TO"
