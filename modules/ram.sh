#!/usr/bin/env bash
set -euo pipefail

check_ram() {
  # % used = used/total * 100
  local usage=$(free -m | awk '/^Mem:/ {printf("%d", ($3/$2)*100)}')
  echo "$usage"
}
