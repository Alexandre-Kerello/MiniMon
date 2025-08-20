#!/usr/bin/env bash
set -euo pipefail

check_disk() {
  local path="${DISK_PATH:-/}"
  df -P "$path" | awk 'NR==2{gsub(/%/,"",$5); print $5}'
}
