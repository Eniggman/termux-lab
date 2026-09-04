#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# tts_speak.sh - Text-to-speech announcement utility
# Part of Enigman Termux Lab (https://github.com/Enigman-Termux-lab)
# ==============================================================================
set -euo pipefail

TEXT="${1:-Termux Lab execution completed.}"

if ! command -v termux-tts-speak >/dev/null 2>&1; then
    echo "ERROR: termux-tts-speak not found. Install via 'pkg install termux-api'." >&2
    exit 1
fi

termux-tts-speak "$TEXT"
