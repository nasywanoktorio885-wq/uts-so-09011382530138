#!/bin/bash
# Nama  : Nasywan Oktorio
# NIM   : 09011382530138
# Kelas : SKU3B
#
# backup_loop.sh
# Menjalankan backup.sh berulang kali dengan jeda INTERVAL detik.
#
# Pemakaian : ./backup_loop.sh &          (jalan di background)
#             INTERVAL=10 ./backup_loop.sh &   (ubah jeda)
# Berhenti  : kill PID   (atau kill %1)

# ---------- Variabel ----------
INTERVAL="${INTERVAL:-60}"   # jeda antar backup (detik), bawaan 60
BACKUP_SCRIPT="$(dirname "$(readlink -f "$0")")/backup.sh"
SLEEP_PID=""

# ---------- Berhenti dengan rapi saat menerima kill / Ctrl+C ----------
trap '[ -n "$SLEEP_PID" ] && kill "$SLEEP_PID" 2>/dev/null; echo "backup_loop.sh (PID $$) dihentikan."; exit 0' TERM INT

echo "backup_loop.sh berjalan, PID $$, interval ${INTERVAL} detik."

# ---------- Perulangan utama ----------
while true; do
    "$BACKUP_SCRIPT" "$@"
    # sleep dijalankan di background lalu ditunggu, agar sinyal kill
    # langsung diproses tanpa menunggu sleep selesai
    sleep "$INTERVAL" &
    SLEEP_PID=$!
    wait "$SLEEP_PID"
done
