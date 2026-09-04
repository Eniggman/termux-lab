#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# clipboard.sh - Safe Android clipboard get/set utility
# Part of Enigman Termux Lab (https://github.com/Enigman-Termux-lab)
# ==============================================================================
set -euo pipefail

ACTION="${1:-get}"

case "$ACTION" in
    get)
        if command -v termux-clipboard-get >/dev/null 2>&1; then
            termux-clipboard-get
        else
            echo "ERROR: termux-clipboard-get not found." >&2
            exit 1
        fi
        ;;
    set)
        if command -v termux-clipboard-set >/dev/null 2>&1; then
            if [ -n "${2:-}" ]; then
                termux-clipboard-set "$2"
            else
                termux-clipboard-set
            fi
            echo "Clipboard updated."
        else
            echo "ERROR: termux-clipboard-set not found." >&2
            exit 1
        fi
        ;;
    *)
        echo "Usage: $0 [get|set [text]]"
        exit 1
        ;;
esac
