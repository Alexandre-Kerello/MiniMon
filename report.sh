#!/usr/bin/env bash
set -euo pipefail

source "/opt/minimon/lib/common.sh"
load_config

source "/opt/minimon/modules/cpu.sh"
source "/opt/minimon/modules/ram.sh"
source "/opt/minimon/modules/disk.sh"
source "/opt/minimon/modules/services.sh"

FORMAT="${1:-txt}" # txt|html|json
CPU=$(cpu_used_pct)
RAM=$(ram_used_pct)
DISK=$(disk_used_pct)
SERV=$(services_status)

case "$FORMAT" in
  txt)
    cat <<TXT
MiniMon – Report
CPU   : ${CPU}%
RAM   : ${RAM}%
DISK  : ${DISK}% (${DISK_PATH:-/})
SERV  : ${SERV}
TXT
    ;;
  html)
    cat <<HTML
<!doctype html><html><head><meta charset="utf-8"><title>MiniMon Report</title></head>
<body style="font-family: sans-serif">
<h1>MiniMon – Report</h1>
<ul>
<li><strong>CPU</strong> : ${CPU}%</li>
<li><strong>RAM</strong> : ${RAM}%</li>
<li><strong>DISK</strong> : ${DISK}% (${DISK_PATH:-/})</li>
<li><strong>Services</strong> : ${SERV}</li>
</ul>
</body></html>
HTML
    ;;
  json)
    printf '{"cpu":%s,"ram":%s,"disk":%s,"disk_path":"%s","services":"%s"}\n' \
      "$CPU" "$RAM" "$DISK" "${DISK_PATH:-/}" "$SERV"
    ;;
  *)
    error "Unknown format: $FORMAT (expected: txt|html|json)"; exit 1;;
esac
