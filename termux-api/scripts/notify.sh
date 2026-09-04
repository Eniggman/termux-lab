#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# notify.sh - Rich Android Push Notifications via Termux:API
# Part of Enigman Termux Lab (https://github.com/Enigman-Termux-lab)
# ==============================================================================
set -euo pipefail

TITLE="${1:-Termux Lab}"
CONTENT="${2:-Task completed}"
ID="${3:-termux_notify_$$}"
PRIORITY="${4:-high}"

if ! command -v termux-notification >/dev/null 2>&1; then
    echo "ERROR: termux-notification not found. Install via 'pkg install termux-api'." >&2
    exit 1
fi

termux-notification \
    --id "$ID" \
    --title "$TITLE" \
    --content "$CONTENT" \
    --priority "$PRIORITY" \
    --vibrate 50,100,50 \
    --action "am start -n com.termux/com.termux.app.TermuxActivity"

echo "Notification sent: [$TITLE] $CONTENT"
