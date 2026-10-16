# UTS Sistem Operasi: Backup Otomatis

## Identitas
- Nama  : Mechael Arlindra Dwiputra
- NIM   : 09011382530160
- Kelas : SKU3B

## Deskripsi
Script ini mem-backup file catatan `.txt` dari `~/data_09011382530160`.
- `backup.sh`: mencari semua `.txt` dengan `find` (termasuk subdirektori), mengarsipkannya dengan `tar -czvf` ke `~/backup_09011382530160`, menampilkan isi arsip dengan `tar -tzvf`, lalu menambahkan satu baris ke `backup.log`.
- `backup_loop.sh`: menjalankan `backup.sh` berulang dengan `while true` dan `sleep $INTERVAL` (bawaan 60 detik).
- `alias.sh`: mendefinisikan alias `bk160` untuk menjalankan `backup.sh`.

## Cara Menjalankan
```bash
./script/backup.sh
./script/backup_loop.sh &
INTERVAL=10 ./script/backup_loop.sh &
source script/alias.sh && bk160
```

## Fitur Pengembangan
Fitur yang dipilih: **Rotasi arsip**. Setelah backup, hanya 5 arsip terbaru yang disimpan dan sisanya dihapus.

Cara mencoba:
```bash
for i in 1 2 3 4 5 6 7; do ./script/backup.sh > /dev/null; sleep 1; done
ls ~/backup_09011382530160/*.tar.gz | wc -l   # hasil: 5
```

## Bukti Job Control
```
vboxuser@Linux:~/uts-so-09011382530160/script$ INTERVAL=20 ./backup_loop.sh > /dev/null &
[1] 8610
vboxuser@Linux:~/uts-so-09011382530160/script$ jobs -l
[1]+  8610 Running                    INTERVAL=20 ./backup_loop.sh > /dev/null &
vboxuser@Linux:~/uts-so-09011382530160/script$ fg
INTERVAL=20 ./backup_loop.sh > /dev/null
^Z
[1]+  Stopped                    INTERVAL=20 ./backup_loop.sh > /dev/null
vboxuser@Linux:~/uts-so-09011382530160/script$ jobs -l
[1]+  8610 Stopped                    INTERVAL=20 ./backup_loop.sh > /dev/null
vboxuser@Linux:~/uts-so-09011382530160/script$ bg
[1]+ INTERVAL=20 ./backup_loop.sh > /dev/null &
vboxuser@Linux:~/uts-so-09011382530160/script$ ps x | grep -E "PID|backup_loop"
    PID TTY      STAT   TIME COMMAND
   8610 pts/1    S      0:00 /bin/bash ./backup_loop.sh
   8774 pts/1    S+     0:00 grep --color=auto -E PID|backup_loop
vboxuser@Linux:~/uts-so-09011382530160/script$ sleep 25
vboxuser@Linux:~/uts-so-09011382530160/script$ tail -3 ~/backup_09011382530160/backup.log
2026-10-16 18:08:05 | backup_09011382530160_20261016_180805.tar.gz | 14 | 4.0K
2026-10-16 18:08:25 | backup_09011382530160_20261016_180825.tar.gz | 14 | 4.0K
2026-10-16 18:08:46 | backup_09011382530160_20261016_180846.tar.gz | 14 | 4.0K
vboxuser@Linux:~/uts-so-09011382530160/script$ kill %1
[1]+  Terminated                 INTERVAL=20 ./backup_loop.sh > /dev/null
vboxuser@Linux:~/uts-so-09011382530160/script$ jobs -l
```

## Kendala
- `chmod: cannot access 'script/*.sh'`: folder `script` kosong karena `backup.sh` belum tersimpan di sana. Diatasi dengan membuat ulang file di `~/uts-so-09011382530160/script/`.
- `bash: /usr/bin/backup.sh: No such file or directory`: isi script ditempel langsung ke terminal sehingga `$0` bukan nama file. Diatasi dengan menyimpannya sebagai file memakai `cat > ... << 'EOF'`, lalu menjalankannya dengan `./script/backup_loop.sh`.
