#!/bin/bash

# setup_ftp_server_final.sh 
# Hentikan skrip jika ada perintah yang gagal
set -e

# --- PENGATURAN AWAL ---
AINUR_PASS="ainur123"
MELKOR_PASS="melkor123"

echo " ^=^z^` Memulai skrip konfigurasi server vsftpd (versi perbaikan)..."

# --- 1. INSTALASI DAN PEMBUATAN DIREKTORI ---
echo " ^z^y  ^o  Memperbarui daftar paket dan menginstal vsftpd..."
apt-get update > /dev/null
apt-get install -y vsftpd

echo " ^=^s^a Membuat direktori yang dibutuhkan..."
mkdir -p /srv/ftp/shared
mkdir -p /etc/vsftpd_user_conf

# --- 2. PERBAIKAN MASALAH SHELL ---
echo " ^=^t  Memastikan shell '/usr/sbin/nologin' valid di /etc/shells..."
# Menambahkan shell jika belum ada di dalam file
if ! grep -q "/usr/sbin/nologin" /etc/shells; then
    echo "/usr/sbin/nologin" >> /etc/shells
fi

# --- 3. PEMBUATAN USER DAN PENGATURAN PASSWORD OTOMATIS ---
# User ainur
if id -u "ainur" >/dev/null 2>&1; then
    echo " ^=^q  User 'ainur' sudah ada, hanya mengatur ulang password."
else
    echo " ^~^u Membuat user 'ainur'..."
    useradd -d /srv/ftp/shared -s /usr/sbin/nologin ainur
fi
echo " ^=^t^q Mengatur password untuk 'ainur' menjadi '${AINUR_PASS}'..."
echo "ainur:${AINUR_PASS}" | chpasswd

# User melkor
if id -u "melkor" >/dev/null 2>&1; then
    echo " ^=^q  User 'melkor' sudah ada, hanya mengatur ulang password."
else
    echo " ^~^u Membuat user 'melkor'..."
    useradd -m -s /usr/sbin/nologin melkor
fi
echo " ^=^t^q Mengatur password untuk 'melkor' menjadi '${MELKOR_PASS}'..."
echo "melkor:${MELKOR_PASS}" | chpasswd

# Atur kepemilikan direktori
echo " ^=^n  Mengatur kepemilikan direktori /srv/ftp/shared untuk user 'ainur'."
chown ainur:ainur /srv/ftp/shared

# --- 4. KONFIGURASI VSFTPD (METODE BARU) ---
echo " ^=^t  Menulis file konfigurasi utama /etc/vsftpd.conf dengan metode blokir userlist..."
cat <<EOF > /etc/vsftpd.conf
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
pam_service_name=vsftpd
tcp_wrappers=YES

# --- Konfigurasi spesifik untuk user ---
user_config_dir=/etc/vsftpd_user_conf

# --- Konfigurasi Blokir User ---
userlist_enable=YES
userlist_file=/etc/vsftpd.user_list
userlist_deny=YES
EOF

echo " ^|^m  ^o  Menulis konfigurasi khusus untuk 'ainur' (IZINKAN TULIS)..."
echo "write_enable=YES" > /etc/vsftpd_user_conf/ainur

echo " ^=^z  Membuat daftar blokir dan memasukkan 'melkor' ke dalamnya..."
echo "melkor" > /etc/vsftpd.user_list

# --- 5. KONFIGURASI KEAMANAN (TCP WRAPPERS) ---
echo " ^=^t^r Mengizinkan koneksi vsftpd melalui TCP Wrappers di /etc/hosts.allow..."
if ! grep -q "vsftpd: ALL" /etc/hosts.allow; then
    echo "vsftpd: ALL" >> /etc/hosts.allow
fi

# --- 6. RESTART LAYANAN ---
echo " ^=^t^d Merestart layanan vsftpd untuk menerapkan semua perubahan..."
/etc/init.d/vsftpd restart

echo " ^|^e Konfigurasi server FTP selesai!"
echo "   - User 'ainur' (pass: ${AINUR_PASS}) seharusnya bisa login dan read/write."
echo "   - User 'melkor' (pass: ${MELKOR_PASS}) seharusnya DITOLAK saat login."
echo "Silakan lakukan pengujian akhir dari node Manwe."


