#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# sensor_read.sh - One-shot hardware sensor readout
# Part of Enigman Termux Lab (https://github.com/Enigman-Termux-lab)
# ==============================================================================
set -euo pipefail

SENSOR_NAME="${1:-all}"

if ! command -v termux-sensor >/dev/null 2>&1; then
    echo "ERROR: termux-sensor not found. Install via 'pkg install termux-api'." >&2
    exit 1
fi

if [ "$SENSOR_NAME" = "list" ]; then
    termux-sensor -l
elif [ "$SENSOR_NAME" = "all" ]; then
    termux-sensor -n 1
else
    termux-sensor -s "$SENSOR_NAME" -n 1
fi
