# Ringkasan command untuk Soal 10 (Ping Flood).

### BAGIAN 1: PERSIAPAN (MENCARI IP ERU) ###

# Di terminal Eru:
# Cek alamat IP Eru karena tidak diketahui.
ip a
# Hasil: Ditemukan IP Eru adalah 10.71.1.1


### BAGIAN 2: EKSEKUSI SERANGAN (DARI MELKOR) ###

# Di terminal Melkor:
# Jalankan 'spam ping' dengan 100 paket ke IP Eru.
ping -c 100 10.71.1.1


### BAGIAN 3: ANALISIS HASIL ###

# Hasil akhir menunjukkan:
# -> 0% packet loss
# -> RTT rata-rata sangat rendah (misal: 0.319 ms)
# Kesimpulan: Serangan tidak berdampak pada kinerja server Eru.