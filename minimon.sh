#!/usr/bin/env bash

VERSION="0.1"
SELF_DIR="$(dirname "$(readlink -f "$0")")"

LIB_COMMON="/opt/minimon/lib/common.sh"
[ -f "$LIB_COMMON" ] || LIB_COMMON="$SELF_DIR/lib/common.sh"

source "$LIB_COMMON"
load_config

CPU_MOD="/opt/minimon/modules/cpu.sh"; [ -f "$CPU_MOD" ] || CPU_MOD="$SELF_DIR/modules/cpu.sh"
RAM_MOD="/opt/minimon/modules/ram.sh"; [ -f "$RAM_MOD" ] || RAM_MOD="$SELF_DIR/modules/ram.sh"
DISK_MOD="/opt/minimon/modules/disk.sh"; [ -f "$DISK_MOD" ] || DISK_MOD="$SELF_DIR/modules/disk.sh"
SERV_MOD="/opt/minimon/modules/services.sh"; [ -f "$SERV_MOD" ] || SERV_MOD="$SELF_DIR/modules/services.sh"

source "$CPU_MOD"
source "$RAM_MOD"
source "$DISK_MOD"
source "$SERV_MOD"

usage() {
  cat <<USG
${APP_NAME} v${VERSION}
Usage: minimon [options]
  --report [txt|html|json]  	Generates a report to stdout
  --no-alerts			Disables sending alerts
  --quiet			Compact output
  -h, --help			Help
USG
}

REPORT_FMT="txt"
NO_ALERTS=false
QUIET=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --report) REPORT_FMT="${2:-txt}"; shift 2;;
    --no-alerts) NO_ALERTS=true; shift;;
    --quiet) QUIET=true; shift;;
    -h|--help) usage; exit 0;;
    *) warn "Unknown option: $1"; usage; exit 1;;
  esac
done

ALERT_COUNT=0

CPU_ICON=""
CPU=$(check_cpu)
if [ "$CPU" -gt "$CPU_ALERT" ]; then
  ((ALERT_COUNT++))
  CPU_ICON="⚠️"
fi

RAM_ICON=""
RAM=$(check_ram)
if [ "$RAM" -gt "$RAM_ALERT" ]; then
  ((ALERT_COUNT++))
  RAM_ICON="⚠️"
fi

DISK_ICON=""
DISK=$(check_disk)
if [ "$DISK" -gt "$DISK_ALERT" ]; then
  ((ALERT_COUNT++))
  DISK_ICON="⚠️"
fi

SERV=$(check_services)

# Terminal view
if ! $QUIET; then
  echo "⚡ ${APP_NAME} - System status"
  echo "CPU usage  : ${CPU}% $CPU_ICON"
  echo "RAM usage  : ${RAM}% $RAM_ICON"
  echo "Disk usage : ${DISK}% (${DISK_PATH:-/}) $DISK_ICON"
  echo "Services   : ${SERV}"
  if [ "$ALERT_COUNT" -gt 0 ]; then
    echo "Alerts     : ${ALERT_COUNT} threshold(s) exceeded ⚠️"
  else
    echo "Alerts     : ${ALERT_COUNT} threshold exceeded"
  fi
fi

# Alerts
if ! $NO_ALERTS; then
  ([ "$CPU" -ge "${CPU_ALERT}" ] && send_alert "High CPU: ${CPU}%") || true
  ([ "$RAM" -ge "${RAM_ALERT}" ] && send_alert "High RAM: ${RAM}%") || true
  ([ "$DISK" -ge "${DISK_ALERT}" ] && send_alert "Disk (${DISK_PATH:-/}) at ${DISK}%") || true
  # Down services alerts
  if [[ -n "${SERV}" ]]; then
    if echo "$SERV" | grep -q "DOWN"; then
      send_alert "Service(s) down: $(echo "$SERV" | sed 's/\s\+/ /g')"
    fi
  fi
fi

# Report
([ ! -d "$REPORT_DIR" ] && mkdir -p "$REPORT_DIR") || true
if [[ -n "$REPORT_FMT" ]]; then
  REP_BIN="/opt/minimon/report.sh"; [ -f "$REP_BIN" ] || REP_BIN="$SELF_DIR/report.sh"
  "$REP_BIN" "$REPORT_FMT"
fi

exit 0
