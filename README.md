# UTS Sistem Operasi - Backup Otomatis

## Identitas

- Nama  : Nasywan Oktorio
- NIM   : 09011282530001
- Kelas : [ISI KELAS]

## Deskripsi

Repositori ini berisi tiga *shell script* untuk mencadangkan file catatan praktikum.

- `script/backup.sh` memakai `find` untuk mencari semua file `.txt` (termasuk subdirektori) di `~/data_09011282530001`, menyimpan daftarnya ke `~/backup_09011282530001/daftar_file.txt`, lalu membuat arsip `backup_09011282530001_TANGGAL_JAM.tar.gz` dengan `tar -czvf`. Isi arsip ditampilkan dengan `tar -tzvf`, kemudian satu baris ditambahkan ke `~/backup_09011282530001/backup.log` dengan `>>` dalam format `tanggal jam | nama arsip | jumlah file | ukuran`.
- `script/backup_loop.sh` menjalankan `backup.sh` berulang dengan `while true` dan `sleep`. Jeda disimpan di variabel `INTERVAL` (bawaan 60 detik).
- `script/alias.sh` mendefinisikan alias `bk001` yang menjalankan `backup.sh`.

## Cara menjalankan

Siapkan data uji terlebih dahulu:

```bash
mkdir -p ~/data_09011282530001/sub1 ~/data_09011282530001/sub2
for i in $(seq 1 10); do echo "catatan $i" > ~/data_09011282530001/catatan$i.txt; done
touch ~/data_09011282530001/gambar.png ~/data_09011282530001/data.csv
echo a > ~/data_09011282530001/sub1/a.txt; echo b > ~/data_09011282530001/sub1/b.txt
echo c > ~/data_09011282530001/sub2/c.txt; echo d > ~/data_09011282530001/sub2/d.txt
```

Jalankan script:

```bash
cd ~/uts-so-09011282530001
./script/backup.sh                    # sekali backup
./script/backup_loop.sh &             # backup berulang di background (jeda 60 detik)
INTERVAL=10 ./script/backup_loop.sh & # jeda 10 detik
kill %1                               # hentikan job 1 (atau: kill PID)
source script/alias.sh && bk001       # lewat alias
```

## Fitur pengembangan

Fitur yang dipilih: **Parameter**. Ekstensi file dan direktori sumber dapat diberikan sebagai argumen.

```bash
./script/backup.sh              # ekstensi txt, sumber ~/data_09011282530001
./script/backup.sh pdf          # hanya file .pdf
./script/backup.sh txt ~/folder # file .txt dari direktori lain
```

## Bukti job control

Keluaran terminal saat menjalankan `./backup_loop.sh &`, `jobs -l`, `fg`, Ctrl+Z, `bg`, `ps x`, dan `kill`:

```text
(tempel keluaran terminal Anda di sini)
```

## Kendala

(Tulis error yang benar-benar Anda alami dan cara mengatasinya.)
