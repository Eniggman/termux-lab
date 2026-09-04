#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# toast.sh - Android Popup Toast notification
# Part of Enigman Termux Lab (https://github.com/Enigman-Termux-lab)
# ==============================================================================
set -euo pipefail

MESSAGE="${1:-Ready}"
BG_COLOR="${2:-#24292e}"
TEXT_COLOR="${3:-#ffffff}"

if ! command -v termux-toast >/dev/null 2>&1; then
    echo "ERROR: termux-toast not found. Install via 'pkg install termux-api'." >&2
    exit 1
fi

termux-toast -b "$BG_COLOR" -c "$TEXT_COLOR" "$MESSAGE"
