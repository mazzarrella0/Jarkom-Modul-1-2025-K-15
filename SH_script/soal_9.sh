#!/bin/bash

# Ringkasan command untuk Soal 9, termasuk troubleshooting.

### BAGIAN 1: PERSIAPAN DI SERVER ERU ###

# 1. Download file 'kitab_penciptaan.zip' ke Eru.
wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=11ua2KgBu3MnHEIjhBnzqqv2RMEiJsILY' -O kitab_penciptaan.zip

# 2. Pindah file (gagal karena node di-restart, direktori tidak ada).
# mv kitab_penciptaan.zip /srv/ftp/shared/

# SOLUSI: Jalankan ulang skrip setup FTP (dari Soal 7) untuk membangun ulang server.
# ./setup_ftp_server_final.sh

# 3. Ulangi unduh dan pindah file (sekarang berhasil).
wget --no-check-certificate 'https://drive.google.com/uc?export=download&id=11ua2KgBu3MnHEIjhBnzqqv2RMEiJsILY' -O kitab_penciptaan.zip
mv kitab_penciptaan.zip /srv/ftp/shared/

# 4. Ubah hak akses 'ainur' menjadi read-only.
echo "write_enable=NO" > /etc/vsftpd_user_conf/ainur

# 5. Terapkan perubahan dengan merestart layanan vsftpd.
/etc/init.d/vsftpd restart

### BAGIAN 2: AKSI DI CLIENT MANWE ###

# 6. Coba koneksi FTP (gagal, 'command not found' karena node di-restart).
# ftp 10.71.1.1 21

# SOLUSI: Perbaiki DNS di Manwe lalu install ulang FTP client.
# echo "nameserver 8.8.8.8" > /etc/resolv.conf
# apt-get update && apt-get install ftp -y

# 7. Lakukan koneksi, download, dan uji coba read-only.
# Di dalam sesi FTP interaktif, jalankan perintah berikut:
# > user ainur ainur123
# > get kitab_penciptaan.zip  (Akan berhasil)
# > put file_gagal.txt       (Akan GAGAL dengan 'Permission denied')
# > bye