#!/bin/bash

check_services() {
 local ouput=""
 for service in "${SERVICES[@]}"; do
  if systemctl is-active --quiet "$service"; then
   output+="$service ✅"
  else
   output+="$service ❌"
  fi
 done
 echo "$output"
}
