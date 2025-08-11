#!/bin/bash

message="$1"
url="https://api.telegram.org/bot$TELEGRAM_TOKEN/sendMessage"

curl -s -X POST "$url" -d chat_id="$TELEGRAM_CHAT_ID" -d text=⚠️ MiniMon:n: $message" > /dev/null
