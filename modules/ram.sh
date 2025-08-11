#!/bin/bash

check_ram() {
 local free_mem=$(free -m | awk '^/Mem:/ {print $7}')
 echo "$free_mem"
}
