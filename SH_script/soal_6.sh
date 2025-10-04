# Ringkasan command untuk Soal 6 (Analisis Trafik & Filter Wireshark).

### BAGIAN 1: PERSIAPAN SCRIPT (DI MANWE) ###

# 1. Unduh file skrip dari Google Drive.
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1bE3kF1Nclw0VyKq4bL2VtOOt53IC7lG5' -O traffic.zip

# 2. Install 'unzip' (jika perlu) dan ekstrak file.
apt-get update && apt-get install unzip -y
unzip traffic.zip

# 3. Berikan izin eksekusi pada skrip.
chmod +x traffic.sh


### BAGIAN 2: EKSEKUSI DAN ANALISIS ###

# 4. (Di Komputer Host) Jalankan Wireshark dan mulai capture pada koneksi Manwe.

# 5. (Di Manwe) Jalankan skrip untuk menghasilkan lalu lintas jaringan.
./traffic.sh
# Biarkan berjalan beberapa detik, lalu hentikan dengan Ctrl+C.

# 6. (Di Komputer Host) Hentikan capture di Wireshark.

# 7. (Di Wireshark) Terapkan display filter untuk mengisolasi trafik Manwe.
# Contoh filter (ganti IP jika perlu):
# ip.addr == 10.71.1.3
