#!/bin/bash

check_services() {
 local ouput=""
 for service in "${SERVICES[@]}"; do
  if systemctl is-active --quiet "$service"; then
   output+="  ▶ $service ✅\n"
  else
   output+="  ▶ $service ❌\n"
  fi
 done
 echo "$output"
}
