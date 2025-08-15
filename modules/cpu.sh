#!/usr/bin/env bash
set -euo pipefail

check_cpu() {
 local usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1)
 echo "$usage"
}

cpu_used_pct() {
  local idle
  idle=$(top -bn1 | awk -F',' '/Cpu\(s\)/{for(i=1;i<=NF;i++){if($i~/%id/){gsub(/[^0-9.]/, "", $i); print $i; exit}}}')
  if [[ -z "$idle" ]]; then
    idle=$(mpstat 1 1 | awk '/Average/ {print 100-$NF}') || idle=0
  fi
  # shellcheck disable=SC2046
  printf '%d' "$(awk 'BEGIN{print (100 - ${idle:-0})}')"
}
