#!/usr/bin/env bash
set -euo pipefail

check_ram() {
 local free_mem=$(free -m | grep Mem: | awk '{print $7}')
 echo "$free_mem"
}

ram_used_pct() {
  # % used = used/total *100 (free -m)
  free -m | awk '/^Mem:/ {printf("%d", ($3/$2)*100)}'
}
