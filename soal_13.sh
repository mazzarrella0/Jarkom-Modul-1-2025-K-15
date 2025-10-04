# Ringkasan command untuk Soal 13 (Analisis Keamanan SSH).

### BAGIAN 1: PERSIAPAN & TROUBLESHOOTING SERVER (DI ERU) ###

# 1. Pastikan SSH server terinstal.
apt-get update && apt-get install openssh-server -y

# 2. Cek status service. Hasil: 'sshd is not running'.
/etc/init.d/ssh status

# 3. SOLUSI: Start service SSH secara manual.
/etc/init.d/ssh start
# Verifikasi ulang, hasil: 'sshd is running'.


### BAGIAN 2: PERCOBAAN KONEKSI & TROUBLESHOOTING (DARI VARDA) ###

# 4. Pastikan SSH client terinstal di Varda.
# apt-get update && apt-get install openssh-client -y

# 5. Coba koneksi sebagai 'root'. Gagal: 'Permission denied'.
# Ini karena login root via password dinonaktifkan untuk keamanan.
# ssh root@10.71.1.1

# 6. SOLUSI: Gunakan user biasa, yaitu 'ainur'.
# Coba koneksi sebagai 'ainur'. Gagal: 'This account is currently not available'.
# Ini karena shell 'ainur' diatur ke '/usr/sbin/nologin'.
# ssh ainur@10.71.1.1


### BAGIAN 3: MEMPERBAIKI USER & KONEKSI BERHASIL ###

# 7. (Di Eru) SOLUSI FINAL: Ubah shell user 'ainur' menjadi shell interaktif.
usermod -s /bin/bash ainur

# 8. (Di Varda) Ulangi koneksi sebagai 'ainur'. Kali ini berhasil.
# Lakukan ini sambil menjalankan Wireshark.
ssh ainur@10.71.1.1
# Setelah login, jalankan 'ls' lalu 'exit'.


### BAGIAN 4: ANALISIS WIRESHARK ###

# 9. (Di Wireshark) Hentikan capture, filter 'ssh'.
# Klik kanan pada paket -> Follow -> TCP Stream.
# Hasil: Seluruh sesi, termasuk login, terbukti terenkripsi dan tidak bisa dibaca.