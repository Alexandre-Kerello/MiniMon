#!/usr/bin/env bash
set -euo pipefail

for f in /opt/minimon/lib/common.sh /opt/minimon/modules/{cpu,ram,disk,services}.sh; do
  [[ -f "$f" ]] || { echo "Missing file: $f" >&2; exit 1; }
  source "$f"
done
load_config

FORMAT="${1:-txt}" # txt|html|json
FILENAME="minimon_report_$(date +%F_%H-%M-%S)"

CPU=$(check_cpu)
RAM=$(check_ram)
DISK=$(check_disk)
SERV=$(check_services)

escape_json() {
  echo "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

services_to_json() {
  local input="$1"
  local json="{"
  local first=1
  for pair in $input; do
    svc="${pair%%:*}"   # service name
    st="${pair##*:}"    # status
    if [ $first -eq 0 ]; then
      json+=", "
    fi
    json+="\"$svc\": \"$st\""
    first=0
  done
  json+="}"
  echo "$json"
}

case "$FORMAT" in
  txt)
    cat << TXT > "$FILENAME".txt
$(date): MiniMon Report
CPU   : ${CPU}%
RAM   : ${RAM}%
DISK  : ${DISK}% (${DISK_PATH:-/})
SERV  : ${SERV}
TXT
    ;;
  html)
    cat << HTML > "$FILENAME".html
<!doctype html><html><head><meta charset="utf-8"><title>MiniMon Report</title></head>
<body style="font-family: sans-serif">
<h3>$(date): MiniMon Report</h3>
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
    DATE="$(date -Is)"

    CPU_ESC=$(escape_json "$CPU")
    RAM_ESC=$(escape_json "$RAM")
    DISK_ESC=$(escape_json "$DISK")
    PATH_ESC=$(escape_json "${DISK_PATH:-/}")
    SERVICES_JSON=$(services_to_json "$SERV")

    cat << JSON > "$FILENAME".json
{
  "date": "$DATE",
  "cpu": "$CPU_ESC",
  "ram": "$RAM_ESC",
  "disk": "$DISK_ESC",
  "disk_path": "$PATH_ESC",
  "services": $SERVICES_JSON
}
JSON
    ;;
  *)
    error "Unknown format: $FORMAT (expected: txt|html|json)"; exit 1;;
esac
