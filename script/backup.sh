#!/bin/bash
# Nama  : Nasywan Oktorio
# NIM   : 09011382530138
# Kelas : SKU3B
#
# backup.sh
# Mencari semua file .txt di direktori sumber, mengarsipkannya menjadi
# satu file .tar.gz, menampilkan isi arsip, lalu mencatat proses ke log.
#
# Pemakaian : ./backup.sh [ekstensi] [direktori_sumber]
# Contoh    : ./backup.sh          (file .txt, sumber bawaan)
#             ./backup.sh pdf      (file .pdf, sumber bawaan)

# ---------- Variabel (ubah lokasi cukup di bagian ini) ----------
NIM="09011382530138"
EXT="${1:-txt}"                        # ekstensi file, bawaan: txt
SRC_DIR="${2:-$HOME/data_${NIM}}"      # direktori sumber
DEST_DIR="$HOME/backup_${NIM}"         # direktori tujuan backup
LOG_FILE="$DEST_DIR/backup.log"        # file log
LIST_FILE="$DEST_DIR/daftar_file.txt"  # daftar file hasil find

# ---------- Pastikan direktori sumber ada ----------
if [ ! -d "$SRC_DIR" ]; then
    echo "Error: direktori sumber '$SRC_DIR' tidak ditemukan." >&2
    exit 1
fi

# ---------- Buat direktori tujuan jika belum ada ----------
mkdir -p "$DEST_DIR"

# ---------- Cari file dengan find (termasuk subdirektori) ----------
# %P = path relatif terhadap direktori sumber, supaya isi arsip rapi
find "$SRC_DIR" -type f -name "*.${EXT}" -printf '%P\n' > "$LIST_FILE"
COUNT=$(wc -l < "$LIST_FILE" | tr -d ' ')

if [ "$COUNT" -eq 0 ]; then
    echo "Error: tidak ada file .${EXT} di '$SRC_DIR'." >&2
    exit 1
fi

# ---------- Buat arsip dan kompresi ----------
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE_NAME="backup_${NIM}_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="$DEST_DIR/$ARCHIVE_NAME"

tar -czvf "$ARCHIVE_PATH" -C "$SRC_DIR" -T "$LIST_FILE" || {
    echo "Error: pembuatan arsip gagal." >&2
    exit 1
}

# ---------- Verifikasi isi arsip tanpa mengekstrak ----------
echo "Isi arsip $ARCHIVE_NAME:"
tar -tzvf "$ARCHIVE_PATH"

# ---------- Catat ke log (>> menambah, tidak menimpa) ----------
SIZE=$(du -h "$ARCHIVE_PATH" | cut -f1)
echo "$(date '+%Y-%m-%d %H:%M:%S') | $ARCHIVE_NAME | $COUNT | $SIZE" >> "$LOG_FILE"

echo "Backup selesai: $ARCHIVE_PATH"
