#!/usr/bin/env bash
set -euo pipefail

check_disk() {
 local usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
 echo "$usage"
}

disk_used_pct() {
  local path="${DISK_PATH:-/}"
  df -P "$path" | awk 'NR==2{gsub(/%/,"",$5); print $5}'
}
