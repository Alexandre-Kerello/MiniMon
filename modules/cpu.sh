#!/bin/bash

check_cpu() {
 local usage=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1)
 echo "$usage"
}
