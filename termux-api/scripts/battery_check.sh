#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# battery_check.sh - Query Android battery status via Termux:API
# Part of Enigman Termux Lab (https://github.com/Enigman-Termux-lab)
# ==============================================================================
set -euo pipefail

if ! command -v termux-battery-status >/dev/null 2>&1; then
    echo "ERROR: termux-battery-status not found. Install via 'pkg install termux-api'." >&2
    exit 1
fi

RAW_STATUS="$(termux-battery-status 2>/dev/null || true)"
if [ -z "$RAW_STATUS" ]; then
    echo "ERROR: Failed to retrieve battery status from Termux:API companion app." >&2
    exit 2
fi

if [ "${1:-}" = "--json" ]; then
    echo "$RAW_STATUS"
    exit 0
fi

# Parse key fields using python fallback or raw json
if command -v python >/dev/null 2>&1; then
    read -r PERCENT STATUS HEALTH TEMP PLUGGED <<< "$(echo "$RAW_STATUS" | python -c '
import sys, json
data = json.load(sys.stdin)
print(f"{data.get(\"percentage\",\"?\")} {data.get(\"status\",\"?\")} {data.get(\"health\",\"?\")} {data.get(\"temperature\",\"?\")} {data.get(\"plugged\",\"UNPLUGGED\")}")
')"
    echo "🔋 Battery Status:"
    echo "  Level:       ${PERCENT}%"
    echo "  State:       ${STATUS} (${PLUGGED})"
    echo "  Health:      ${HEALTH}"
    echo "  Temperature: ${TEMP}°C"
else
    echo "$RAW_STATUS"
fi
