#!/bin/bash
source "$(dirname "$0")/../config.sh"

subject="⚠️ MiniMon Alert"
body="$1"

cat <<EOF | msmtp --host="$SMTP_SERVER" --port="$SMTP_PORT" \
  --auth=on --user="$SMTP_USER" --passwordeval="echo $SMTP_PASS" \
  --tls=on "$EMAIL_TO"
Subject: $subject

$body
EOF
