#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
RAM_THRESHOLD_MB=500
DISK_THRESHOLD_PERCENT=90

# Services to monitor
SERVICES=("nginx" "sshd" "mysql")

# Telegram Alerts
ENABLE_TELEGRAM=false
TELEGRAM_TOKEN="BOT_TOKEN"
TELEGRAM_CHAT_ID="CHAT_ID"

# Email Alerts
ENABLE_EMAIL=false
SMTP_SERVER="smtp.example.com"
SMTP_PORT=123
SMTP_USER="my_email@example.com"
SMTP_PASS="my_application_password"
EMAIL_TO="recipient@example.com"
