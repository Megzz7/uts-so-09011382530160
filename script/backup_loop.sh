#!/bin/bash
# Nama  : Mechael Arlindra Dwiputra
# NIM   : 09011382530160
# Kelas : SKU3B

INTERVAL="${INTERVAL:-60}"   # jeda dalam detik, bawaan 60
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

while true; do
    "$SCRIPT_DIR/backup.sh"
    sleep "$INTERVAL"
done
