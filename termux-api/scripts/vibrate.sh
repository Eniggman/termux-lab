#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# vibrate.sh - Haptic feedback for agent execution feedback
# Part of Enigman Termux Lab (https://github.com/Enigman-Termux-lab)
# ==============================================================================
set -euo pipefail

DURATION="${1:-40}"

if ! command -v termux-vibrate >/dev/null 2>&1; then
    echo "ERROR: termux-vibrate not found. Install via 'pkg install termux-api'." >&2
    exit 1
fi

termux-vibrate -d "$DURATION"
