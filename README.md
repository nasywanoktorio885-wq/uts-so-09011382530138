# UTS Sistem Operasi - Backup Otomatis

## Identitas

- Nama  : Nasywan Oktorio
- NIM   : 09011382530138
- Kelas : SKU3B

## Deskripsi

Repositori ini berisi tiga *shell script* untuk mencadangkan file catatan praktikum.

- `script/backup.sh` memakai `find` untuk mencari semua file `.txt` (termasuk subdirektori) di `~/data_09011382530138`, menyimpan daftarnya ke `~/backup_09011382530138/daftar_file.txt`, lalu membuat arsip `backup_09011382530138_TANGGAL_JAM.tar.gz` dengan `tar -czvf`. Isi arsip ditampilkan dengan `tar -tzvf`, kemudian satu baris ditambahkan ke `~/backup_09011382530138/backup.log` dengan `>>` dalam format `tanggal jam | nama arsip | jumlah file | ukuran`.
- `script/backup_loop.sh` menjalankan `backup.sh` berulang dengan `while true` dan `sleep`. Jeda disimpan di variabel `INTERVAL` (bawaan 60 detik). Script dijalankan di *background* dengan `&` dan dihentikan dengan `kill`.
- `script/alias.sh` mendefinisikan alias `bk138` (bk + 3 digit terakhir NIM) yang menjalankan `backup.sh`. Baris alias yang sama disalin ke `~/.bashrc`.

## Cara menjalankan

Siapkan data uji terlebih dahulu:

```bash
mkdir -p ~/data_09011382530138/sub1 ~/data_09011382530138/sub2
for i in $(seq 1 10); do echo "catatan $i" > ~/data_09011382530138/catatan$i.txt; done
touch ~/data_09011382530138/gambar.png ~/data_09011382530138/data.csv
echo a > ~/data_09011382530138/sub1/a.txt; echo b > ~/data_09011382530138/sub1/b.txt
echo c > ~/data_09011382530138/sub2/c.txt; echo d > ~/data_09011382530138/sub2/d.txt
```

Jalankan script:

```bash
cd ~/uts-so-09011382530138
./script/backup.sh                    # sekali backup
./script/backup_loop.sh &             # backup berulang di background (jeda 60 detik)
INTERVAL=10 ./script/backup_loop.sh & # jeda 10 detik
kill %1                               # hentikan job 1 (atau: kill PID)
source script/alias.sh && bk138       # lewat alias
```

## Fitur pengembangan

Fitur yang dipilih: **Parameter**. Ekstensi file dan direktori sumber dapat diberikan sebagai argumen. Tanpa argumen, script memakai ekstensi `txt` dan direktori sumber `~/data_09011382530138`. Jika tidak ada file dengan ekstensi yang diminta, script menampilkan pesan error dan berhenti.

Cara mencobanya:

```bash
./script/backup.sh              # ekstensi txt, sumber ~/data_09011382530138
./script/backup.sh csv          # hanya file .csv (di data uji ada data.csv)
./script/backup.sh pdf          # tidak ada file .pdf, muncul pesan error
./script/backup.sh txt ~/folder # file .txt dari direktori lain
```

## Bukti job control

Keluaran terminal saat menjalankan `./backup_loop.sh &`, `jobs -l`, `fg`, Ctrl+Z, `bg`, `ps x`, dan `kill`. Daftar file hasil `find` dan `tar` dipersingkat dengan `...`:

```text
nasywan@nasywan-VirtualBox:~/uts-so-09011382530138$ ./script/backup_loop.sh &
[1] 2805
backup_loop.sh berjalan, PID 2805, interval 60 detik.
(daftar file hasil find dan tar dipersingkat)
Isi arsip backup_09011382530138_20261020_111448.tar.gz:
...
Backup selesai: /home/nasywan/backup_09011382530138/backup_09011382530138_20261020_111448.tar.gz
nasywan@nasywan-VirtualBox:~/uts-so-09011382530138$ jobs -l
[1]+  2805 Running                 ./script/backup_loop.sh &
nasywan@nasywan-VirtualBox:~/uts-so-09011382530138$ fg
./script/backup_loop.sh
^Z
[1]+  Stopped                 ./script/backup_loop.sh
nasywan@nasywan-VirtualBox:~/uts-so-09011382530138$ bg
[1]+ ./script/backup_loop.sh &
(backup berikutnya berjalan otomatis di background, daftar file dipersingkat)
Isi arsip backup_09011382530138_20261020_111548.tar.gz:
...
Backup selesai: /home/nasywan/backup_09011382530138/backup_09011382530138_20261020_111548.tar.gz
nasywan@nasywan-VirtualBox:~/uts-so-09011382530138$ ps x | grep backup_loop
   2805 pts/1    S      0:00 /bin/bash ./script/backup_loop.sh
   2845 pts/1    S+     0:00 grep --color=auto backup_loop
nasywan@nasywan-VirtualBox:~/uts-so-09011382530138$ kill %1
backup_loop.sh (PID 2805) dihentikan.

[1]+  Done                    ./script/backup_loop.sh
nasywan@nasywan-VirtualBox:~/uts-so-09011382530138$ jobs -l
```

## Kendala

- `fatal: not a git repository` dan `No such file or directory` saat menjalankan `git status` dan `./script/backup.sh`: terminal berada di folder home, bukan di folder repositori. Diatasi dengan `cd ~/uts-so-09011382530138`.
- `Error: direktori sumber ... tidak ditemukan`: folder data uji `~/data_09011382530138` belum dibuat. Diatasi dengan membuatnya memakai `mkdir -p` dan `touch`, lalu menjalankan ulang `backup.sh`.
- Nama alias awalnya `bk001`, padahal harus `bk` + 3 digit terakhir NIM. Diubah menjadi `bk138` dengan `sed`, lalu alias dipasang di `~/.bashrc`.
- Menyalin isi terminal untuk bukti job control menghasilkan berkas kosong. Diatasi dengan merekam sesi memakai perintah `script`, lalu membersihkan hasilnya.
- `cd: ... No such file or directory` karena nama folder salah ketik. Diatasi dengan mengetik nama folder yang benar, `~/uts-so-09011382530138`.
