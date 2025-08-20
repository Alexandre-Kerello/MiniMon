#!/usr/bin/env bash
set -euo pipefail

check_services() {
  local s out=""
  for s in "${SERVICES[@]:-}"; do
    if systemctl is-active --quiet "$s" 2>/dev/null; then
      out+="$s:UP  "
    else
      out+="$s:DOWN  "
    fi
  done
  echo "$out"
}
