#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# dialog.sh - Native Android GUI dialogs for scripts and agents
# Part of Enigman Termux Lab (https://github.com/Enigman-Termux-lab)
# ==============================================================================
set -euo pipefail

MODE="${1:-confirm}"
TITLE="${2:-Confirmation}"
HINT="${3:-Please choose an option}"

if ! command -v termux-dialog >/dev/null 2>&1; then
    echo "ERROR: termux-dialog not found. Install via 'pkg install termux-api'." >&2
    exit 1
fi

case "$MODE" in
    confirm)
        termux-dialog confirm -t "$TITLE" -i "$HINT"
        ;;
    text)
        termux-dialog text -t "$TITLE" -i "$HINT"
        ;;
    *)
        echo "Usage: $0 [confirm|text] [title] [hint]"
        exit 1
        ;;
esac
