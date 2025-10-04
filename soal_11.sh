# Ringkasan command untuk Soal 11 (Analisis Keamanan Telnet).

### BAGIAN 1: PERSIAPAN AWAL SERVER (DI MELKOR) ###

# 1. Install server Telnet dan buat user.
apt-get update && apt-get install telnetd -y
useradd -m -s /bin/bash eru_guest
passwd eru_guest


### BAGIAN 2: PERCOBAAN KONEKSI & TROUBLESHOOTING ###

# 2. (Di Eru) Coba koneksi ke IP yang salah. Gagal: Connection refused.
# telnet 10.71.1.1

# 3. (Di Eru) Coba koneksi ke IP Melkor (10.71.1.2). Gagal: Connection refused.
# Ini menandakan service di Melkor belum berjalan.
# telnet 10.71.1.2


### BAGIAN 3: MEMPERBAIKI SERVER TELNET (DI MELKOR) ###

# 4. Coba start service dengan systemd. Gagal: Unit not found.
# systemctl enable telnet.socket

# 5. SOLUSI: Install 'inetd' sebagai manajer layanan.
apt-get install openbsd-inetd -y

# 6. Coba jalankan 'inetd' langsung. Gagal: Port 23 tidak terbuka.
# /usr/sbin/inetd
# netstat -tuln | grep 23

# 7. SOLUSI FINAL: Aktifkan Telnet di file konfigurasi 'inetd'.
# Cek isi file, temukan baris telnet yang di-comment.
cat /etc/inetd.conf

# Edit file untuk menghapus comment '#<off>#' di depan baris telnet.
# nano /etc/inetd.conf

# Restart paksa 'inetd' dan verifikasi.
killall inetd
/usr/sbin/inetd
netstat -tuln | grep 23
# Hasil: Port 23 sekarang 'LISTEN'. Server siap.


### BAGIAN 4: KONEKSI BERHASIL & ANALISIS ###

# 8. (Di Eru) Ulangi koneksi Telnet. Kali ini berhasil.
# Lakukan ini sambil menjalankan Wireshark.
telnet 10.71.1.2
# Login sebagai 'eru_guest' lalu 'exit'.

# 9. (Di Wireshark) Hentikan capture, filter 'telnet'.
# Klik kanan pada paket -> Follow -> TCP Stream.
# Hasil: Username dan password terlihat sebagai plaintext.