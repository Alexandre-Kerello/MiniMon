#!/bin/bash

check_disk() {
 local usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
 echo "$usage"
}
