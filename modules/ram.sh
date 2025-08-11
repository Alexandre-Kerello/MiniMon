#!/bin/bash

check_ram() {
 local free_mem=$(free -m | grep Mem: | awk '{print $7}')
 echo "$free_mem"
}
