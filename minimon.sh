#!/bin/bash

source ./config.sh

source ./modules/cpu.sh
source ./modules/ram.sh
source ./modules/disk.sh
source ./modules/services.sh

alert() {
  local messag="$1"
  echo "⚠️ Warning: $message"

  if [ "$ENABLE_TELEGRAM" = true ]; then
    ./alerts/telegram.sh "$message"
  fi
}

echo "⚙️ MiniMon - System supervision 📈"
echo "----------------------------------"

CPU_USAGE=$(check_cpu)
RAM_AVAILABLE=$(check_ram)
DISK_USAGE=$(check_disk)
SERVICES_STATUSES=$(check_services)

echo "CPU: $CPU_USAGE%"
[ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ] && alert "High CPU: $CPU_USAGE%"

echo "RAM available: $RAM_AVAILABLE MB"
[ "$RAM_AVAILABLE" -lt "$RAM_THRESHOLD_MB" ] && alert "Low RAM: $RAM_AVAILABLE MB"

echo "DISK: $DISK_USAGE%"
[ "$DISK_USAGE" -gt "$DISK_THRESHOLD_PERCENT" ] && alert "Full disk: $DISK_USAGE%"

echo -e "Services :\n$SERVICES_STATUSES"

echo -e "\033[1A----------------------------------"
