#!/usr/bin/env bash

VERSION="0.1.0"
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

REPORT_FMT=""
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

CPU_USAGE=$(cpu_used_pct)
RAM_AVAILABLE=$(check_ram)
DISK_USAGE=$(check_disk)
SERVICES_STATUSES=$(check_services)

# Terminal view
if ! $QUIET; then
  echo "📡 ${APP_NAME} – System status"
  echo "CPU  : ${CPU_USAGE}% | threshold ${CPU_ALERT}%"
  echo "RAM  : ${RAM_AVAILABLE}% | threshold ${RAM_ALERT}%"
  echo "DISK : ${DISK_USAGE}% (${DISK_PATH:-/}) | threshold ${DISK_ALERT}%"
  echo "SERV : ${SERVICES_STATUSES}"
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
if [[ -n "$REPORT_FMT" ]]; then
  REP_BIN="/opt/minimon/report.sh"; [ -f "$REP_BIN" ] || REP_BIN="$SELF_DIR/report.sh"
  "$REP_BIN" "$REPORT_FMT"
fi

exit 0

