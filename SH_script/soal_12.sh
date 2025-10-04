# Ringkasan command untuk Soal 12 (Netcat Port Scan).

### BAGIAN 1: PERCOBAAN AWAL (DARI ERU) ###

# 1. Coba pindai port 21. Gagal: 'nc: command not found'.
# nc -vzw 1 10.71.1.2 21

# 2. SOLUSI: Install Netcat. Nama paket yang benar adalah 'netcat-traditional'.
apt-get install netcat-traditional -y

# 3. Ulangi pindai port 21. Gagal: 'Connection refused' (port tertutup).
# Ini karena belum ada layanan FTP di Melkor.
nc -vzw 1 10.71.1.2 21


### BAGIAN 2: MEMPERSIAPKAN SERVER (DI MELKOR) ###

# 4. SOLUSI: Install layanan yang diperlukan di Melkor agar port terbuka.
# Install FTP Server untuk membuka port 21.
apt-get install vsftpd -y
/etc/init.d/vsftpd start

# 5. Install Web Server untuk membuka port 80.
apt-get install nginx -y

# 6. Service nginx gagal start otomatis. Start manual.
# /etc/init.d/nginx status
/etc/init.d/nginx start


### BAGIAN 3: PEMINDAIAN AKHIR (DARI ERU) ###

# 7. Ulangi pemindaian. Kali ini semua hasil sesuai dengan soal.
# Port 21 (FTP) -> Hasil: 'open'
nc -vzw 1 10.71.1.2 21

# Port 80 (HTTP) -> Hasil: 'open'
nc -vzw 1 10.71.1.2 80

# Port 666 -> Hasil: 'Connection refused' (tertutup)
nc -vzw 1 10.71.1.2 666