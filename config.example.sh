# === MiniMon configuration file ===
# Email alert via SMTP (optional)
ENABLE_EMAIL=false
SMTP_SERVER="smtp.example.com"
SMTP_PORT=587
SMTP_TLS=true           # true|false
SMTP_USER=""
SMTP_PASS=""
EMAIL_FROM="minimon@localhost"
EMAIL_TO=""

# Telegram alert (optional)
ENABLE_TELEGRAM=false
TELEGRAM_TOKEN=""
TELEGRAM_CHAT_ID=""

# Alerts threshold (%)
CPU_ALERT=85            # % CPU used
RAM_ALERT=90            # % RAM used
DISK_ALERT=90           # % disk used on DISK_PATH
DISK_PATH="/"          # mount point to watch

# Services to monitor (systemd)
SERVICES=("ssh" "cron")

# Miscellaneous
LOG_FILE="/var/log/minimon.log"   # usefull if using cron
REPORT_DIR="/home/$USER"
