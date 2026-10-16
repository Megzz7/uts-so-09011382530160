#!/bin/bash
# Nama  : Mechael Arlindra Dwiputra
# NIM   : 09011382530160
# Kelas : SKU3B

# ===== Variabel (ubah di sini saja) =====
NIM="09011382530160"
SRC_DIR="$HOME/data_$NIM"
DEST_DIR="$HOME/backup_$NIM"
LOG_FILE="$DEST_DIR/backup.log"
LIST_FILE="$DEST_DIR/daftar_file.txt"
MAX_ARSIP=5

# ===== Buat direktori tujuan jika belum ada =====
mkdir -p "$DEST_DIR"

# ===== Cari semua .txt (termasuk subdirektori) =====
find "$SRC_DIR" -type f -name "*.txt" -printf "%P\n" > "$LIST_FILE"
JUMLAH=$(wc -l < "$LIST_FILE")

if [ "$JUMLAH" -eq 0 ]; then
    echo "Tidak ada file .txt di $SRC_DIR"
    exit 1
fi

# ===== Buat arsip =====
WAKTU=$(date +%Y%m%d_%H%M%S)
NAMA_ARSIP="backup_${NIM}_${WAKTU}.tar.gz"
tar -czvf "$DEST_DIR/$NAMA_ARSIP" -C "$SRC_DIR" -T "$LIST_FILE"

# ===== Verifikasi isi arsip (tanpa ekstrak) =====
echo "--- Isi arsip ---"
tar -tzvf "$DEST_DIR/$NAMA_ARSIP"

# ===== Catat ke log (tepat satu baris, pakai >>) =====
UKURAN=$(du -h "$DEST_DIR/$NAMA_ARSIP" | cut -f1)
echo "$(date '+%Y-%m-%d %H:%M:%S') | $NAMA_ARSIP | $JUMLAH | $UKURAN" >> "$LOG_FILE"

# ===== Fitur: rotasi, simpan hanya 5 arsip terbaru =====
ls -1t "$DEST_DIR"/backup_${NIM}_*.tar.gz | tail -n +$((MAX_ARSIP + 1)) | xargs -r rm --
