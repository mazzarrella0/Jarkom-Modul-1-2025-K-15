# Laporan Praktikum Jaringan: Konfigurasi Jaringan Ainulindalë

## Deskripsi Proyek

Proyek ini bertujuan untuk membangun dan mengkonfigurasi sebuah topologi jaringan berdasarkan skenario "The Ainulindalë", dengan mengikuti prosedur dan konsep yang dijelaskan dalam **Modul Pengenalan GNS3**. Laporan ini merinci implementasi untuk setiap tahapan konfigurasi, mulai dari pembuatan topologi dasar hingga menyediakan konektivitas internet untuk semua node client.

## Topologi Jaringan

Topologi yang digunakan melibatkan satu node **Eru** sebagai Router pusat, dua Switch yang memisahkan empat node **Client** (Melkor, Manwe, Varda, Ulmo) ke dalam dua subnet, dan satu cloud **NAT** sebagai gerbang ke Internet. Semua node menggunakan image Docker `nevarre/gns3-debi:latest` sesuai ketentuan.

![Topologi Jaringan](Screenshot 2025-10-01 134603.png)

---

## Implementasi Skenario

Berikut adalah penjelasan untuk setiap objektif yang diselesaikan dalam praktikum, yang dihubungkan dengan materi dari modul.

### Soal 1: Konfigurasi Eru sebagai Router dan Pembuatan Segmen Jaringan

**Objektif:** Membangun fondasi jaringan dengan menjadikan Eru sebagai router pusat yang menghubungkan dua segmen jaringan (subnet) yang terisolasi untuk para Ainur.

**Konsep & Implementasi :**
Sesuai dengan bagian **"Membuat Topologi"** pada modul, konfigurasi jaringan untuk setiap node dilakukan melalui fitur GNS3 **"Edit network configuration"**.

1.  **Eru sebagai Gateway:** Node Eru dikonfigurasi dengan dua antarmuka jaringan statis (`eth1` dan `eth2`). Setiap antarmuka diberikan alamat IP yang unik (`10.71.1.1` dan `10.71.2.1`) yang berfungsi sebagai **gateway** untuk masing-masing segmen jaringan yang terhubung ke Switch1 dan Switch2.<br>
<br>

Dimana konfigurasi node `Eru` :
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 10.71.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 10.71.2.1
	netmask 255.255.255.0

up apt update && apt install iptables
up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.71.0.0/16
```

2.  **Client di Setiap Segmen:** Setiap node client (Melkor, Manwe, Varda, Ulmo) juga dikonfigurasi melalui "Edit network configuration". Mereka diberikan alamat IP statis yang sesuai dengan subnetnya. Parameter **`gateway`** di dalam konfigurasi setiap client diisi dengan alamat IP antarmuka Eru yang relevan, mengarahkan semua trafik eksternal mereka melalui Eru.<br>
<br>

Dimana konfigurasi node `Melkor` :
```
auto eth0
iface eth0 inet static
	address 10.71.1.2
	netmask 255.255.255.0
	gateway 10.71.1.1
```

Dimana konfigurasi node `Manwe` :
```
auto eth0
iface eth0 inet static
	address 10.71.1.3
	netmask 255.255.255.0
	gateway 10.71.1.1
```

Dimana konfigurasi node `Varda` :
```
auto eth0
iface eth0 inet static
	address 10.71.2.2
	netmask 255.255.255.0
	gateway 10.71.2.1
```

Dimana konfigurasi node `Ulmo` :
```
auto eth0
iface eth0 inet static
	address 10.71.2.3
	netmask 255.255.255.0
	gateway 10.71.2.1
```

### Soal 2: Menghubungkan Eru ke Internet

**Objektif:** Memberikan konektivitas internet kepada node router Eru agar ia dapat berkomunikasi dengan dunia luar.

**Konsep & Implementasi :**
Mengikuti panduan **"Akses Sebuah Node ke Internet"**, antarmuka `eth0` pada Eru dihubungkan ke node **NAT** GNS3. Konfigurasi untuk mendapatkan IP secara otomatis dilakukan dengan mengedit file network configuration Eru. Untuk menyambungkan Eru dan internet diperlukan untuk menjalankan langkah langkah ini terlebih dahulu : <br>

**Pembuatan File install_tools.sh (shortcut)**
```
#!/bin/bash
# Script untuk menginstal alat-alat dasar

echo "Memperbarui daftar paket..."
apt update && apt install iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 10.71.0.0/16
echo nameserver 192.168.122.1 > /etc/resolv.conf

echo "Instalasi selesai!"
```

Setelah dijalankannya file tersebut `./install_tools.sh` maka untuk mengecek apakah Eru connect ke internet adalah dengan :
```
ping google.com -c [jumlah tes]
```

**Contoh**
```
root@Eru:~# ping google.com -c 2
PING google.com (142.251.12.139) 56(84) bytes of data.
64 bytes from se-in-f139.1e100.net (142.251.12.139): icmp_seq=1 ttl=102 time=19.6 ms
64 bytes from se-in-f139.1e100.net (142.251.12.139): icmp_seq=2 ttl=102 time=19.8 ms

--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1110ms
rtt min/avg/max/mdev = 19.626/19.715/19.804/0.089 ms
```

### Soal 3: Mengaktifkan Routing Antar-Client

**Objektif:** Memungkinkan komunikasi antara client yang berada di subnet yang berbeda (misalnya, Melkor bisa berkomunikasi dengan Varda).

**Konsep & Implementasi :**
Contoh Implementasi untuk membuktikan bahwa jaringan komputer tersebut bisa terhubung :
```
root@Melkor:~# ping -c 4 10.71.2.2
PING 10.71.2.2 (10.71.2.2) 56(84) bytes of data.
64 bytes from 10.71.2.2: icmp_seq=1 ttl=63 time=1.48 ms
64 bytes from 10.71.2.2: icmp_seq=2 ttl=63 time=0.783 ms
64 bytes from 10.71.2.2: icmp_seq=3 ttl=63 time=0.701 ms
64 bytes from 10.71.2.2: icmp_seq=4 ttl=63 time=0.773 ms

--- 10.71.2.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3380ms
rtt min/avg/max/mdev = 0.701/0.933/1.476/0.314 ms
```
Di Contoh implementasi diatas, saya masuk ke dalam root melkor dan mencoba untuk mengirimkan sinyal ke ip nya **Varda**

### Soal 4: Memberikan Akses Internet untuk Semua Client

**Objektif:** Memungkinkan semua client di jaringan privat (subnet `10.71.1.0/24` dan `10.71.2.0/24`) untuk mengakses internet melalui satu koneksi yang dimiliki oleh router Eru.

**Konsep & Implementasi:**
Agar semua client dapat mengakses internet, dua konfigurasi kunci perlu diterapkan: **NAT (Network Address Translation)** pada router Eru, dan konfigurasi **DNS (Domain Name System)** pada setiap client.

#### 1. Konfigurasi NAT di Eru (Router)

**Konsep:**
Client memiliki alamat IP privat yang tidak dikenali di internet. Oleh karena itu, Eru harus bertindak sebagai perantara yang "menyamarkan" trafik dari client seolah-olah berasal dari dirinya sendiri. Proses ini disebut NAT. Untuk mengimplementasikan NAT pada sistem Linux, kita menggunakan utilitas `iptables`.

```
**Apa itu `iptables` dan mengapa ini perlu?**
`iptables` adalah program utilitas standar di Linux yang berfungsi sebagai antarmuka untuk mengelola firewall kernel (Netfilter). Fungsinya bukan hanya untuk memblokir atau mengizinkan koneksi, tetapi juga untuk melakukan manipulasi paket tingkat lanjut. `iptables` diperlukan di sini karena ia adalah alat yang kita gunakan untuk membuat aturan NAT, yaitu memberitahu kernel Linux agar secara aktif mengubah alamat IP sumber pada paket yang melintasinya.

**Implementasi di `root@Eru`:**
Perintah `iptables` berikut dijalankan untuk mengaktifkan NAT:

bash
# Memastikan iptables terinstal
apt update && apt install iptables -y

# Membuat aturan NAT Masquerade
iptables -t nat -A POSTROUTING -s 10.71.0.0/16 -o eth0 -j MASQUERADE
```

Penjelasan Detail Perintah `iptables`:
Setiap bagian dari perintah ini memiliki fungsi yang sangat spesifik:

- -t nat: Menentukan bahwa kita ingin bekerja pada tabel nat, yang khusus menangani aturan-aturan translasi alamat jaringan.

- -A POSTROUTING: Menambahkan (-A) aturan baru ke chain POSTROUTING. Chain ini akan memproses paket setelah keputusan routing dibuat dan tepat sebelum paket tersebut dikirim keluar dari antarmuka jaringan Eru. Ini adalah titik yang sempurna untuk mengubah alamat IP sumber.

- -s 10.71.0.0/16: Menentukan source (-s) atau sumber trafik. Aturan ini hanya akan berlaku untuk paket yang berasal dari jaringan 10.71.0.0/16 (mencakup kedua subnet client Anda, 10.71.1.x dan 10.71.2.x).

- -o eth0: Menentukan output interface (-o). Aturan ini hanya berlaku untuk paket yang akan keluar melalui antarmuka eth0, yang merupakan jalur Eru ke internet.

- -j MASQUERADE: Menentukan aksi (-j atau jump) yang harus dilakukan adalah MASQUERADE. Aksi ini secara otomatis mengganti alamat IP sumber paket (misalnya, IP Melkor 10.71.1.2) dengan alamat IP yang ada pada antarmuka eth0 Eru.

2. Konfigurasi DNS di Client
Konsep:
Setelah NAT dikonfigurasi, client sudah memiliki jalur ke internet, tetapi mereka belum bisa menggunakan nama domain seperti google.com. Untuk itu, setiap client harus tahu alamat server DNS yang harus dihubungi untuk menerjemahkan nama domain menjadi alamat IP.

Implementasi di root@Varda (dan client lainnya):
Kita mengkonfigurasi setiap client untuk menggunakan server DNS yang sama dengan yang digunakan oleh Eru (misalnya 192.168.122.1).

```
# Mengatur DNS Server untuk Varda
root@Varda:~# echo "nameserver 192.168.122.1" > /etc/resolv.conf
```
*Catatan: Langkah ini perlu diulangi untuk semua client (Melkor, Manwe, dan Ulmo) agar semuanya bisa mengakses internet dengan nama domain.*

3. Verifikasi
Konsep:
Tes akhir yang paling efektif adalah melakukan ping ke nama domain publik dari salah satu client. Keberhasilan tes ini membuktikan bahwa kedua sistem (NAT dan DNS) bekerja sama dengan baik.

Implementasi di root@Varda:
```
root@Varda:~# ping google.com -c 2
PING google.com (142.251.12.101) 56(84) bytes of data.
64 bytes from se-in-f101.1e100.net (142.251.12.101): icmp_seq=1 ttl=100 time=19.7 ms
64 bytes from se-in-f101.1e100.net (142.251.12.101): icmp_seq=2 ttl=100 time=20.0 ms

--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1110ms
rtt min/avg/max/mdev = 19.719/19.837/19.956/0.118 ms
```
Hasil 0% packet loss ini mengonfirmasi bahwa:
1. DNS berfungsi: Varda berhasil menerjemahkan google.com menjadi alamat IP.
2. NAT berfungsi: Paket ping dari IP privat Varda berhasil disamarkan oleh Eru, dikirim ke Google, dan balasannya berhasil dikembalikan lagi ke Varda.

### Soal 5: Membuat Config agar tidak hilang ketika di restart
Langkah-langkah yang saya lakukan adalah dengan masuk ke `GNS3 Client` lalu melakukan editing di config baik router dan juga client dengan cara klik kanan di simbolnya :<br>
![Topologi Jaringan](Screenshot 2025-10-01 134603.png)

Lalu menekan edit config dan perbarui confignya (misal ini eru, untuk clent yang perlu di tambahkan hanya `echo nameserver ...` saja :<br>
![Topologi Jaringan](Screenshot 2025-10-01 134603.png)

Restart ulang dan ketika login ke Router ataupun Client maka akan otomatis menjalankan **config tersebut**.

### Soal 6: Melkor ingin menyusup antara Manwe dan Eru, serta menampilkan paket di IP Adress Manwe

**Objektif:**
Tujuan dari tugas ini adalah untuk mengunduh, menyiapkan, dan mengeksekusi sebuah skrip penghasil lalu lintas (`traffic.sh`) di node **Manwe**. Seluruh proses ini direkam menggunakan Wireshark, kemudian dianalisis dengan menerapkan *display filter* spesifik untuk mengisolasi semua paket yang berasal dari atau menuju ke Manwe.

**Konsep & Implementasi:**
Proses ini melibatkan beberapa tahapan: persiapan file di node target, penyesuaian izin file di Linux, eksekusi skrip, dan analisis hasil rekaman jaringan.

#### 1. Langkah Persiapan: Mengunduh dan Mengekstrak File

**Konsep:**
Langkah pertama adalah mendapatkan file skrip yang diperlukan dari sumber eksternal (Google Drive) ke dalam lingkungan GNS3, tepatnya di node Manwe.

**Implementasi di `root@Manwe`:**
Pertama, sesi terminal dibuka ke node `Manwe`. Kemudian, utilitas `wget` digunakan untuk mengunduh file `traffic.zip`. Setelah itu, file tersebut diekstrak menggunakan perintah `unzip`.

# Mengunduh file dari Google Drive
wget --no-check-certificate "[https://docs.google.com/uc?export=download&id=1bE3kF1Nclw0VyKq4bL2VtOOt53IC7lG5](https://docs.google.com/uc?export=download&id=1bE3kF1Nclw0VyKq4bL2VtOOt53IC7lG5)" -O traffic.zip

# Mengekstrak file .zip
unzip traffic.zip

#### 2. Langkah Pelaksanaan: Packet Sniffing dan Eksekusi Skrip
Konsep:
Sebelum skrip dijalankan, proses packet sniffing harus dimulai untuk memastikan semua aktivitas jaringan terekam. Selain itu, skrip yang baru diunduh seringkali tidak memiliki izin eksekusi (execute permission) secara default, sehingga izin ini harus diberikan secara manual menggunakan perintah chmod.

Implementasi:

1. (Di Komputer Anda): Wireshark dijalankan dan proses capture dimulai pada koneksi antara node Manwe dan Switch1.

2. (Di terminal root@Manwe): Saat mencoba menjalankan skrip (./traffic.sh), ditemukan error Permission denied. Untuk mengatasinya, izin eksekusi ditambahkan ke file skrip.
```
# Menambahkan (+) izin eksekusi (x) ke file traffic.sh
chmod +x traffic.sh
```

3. (Di terminal root@Manwe): Setelah izin diberikan, skrip dieksekusi untuk mulai menghasilkan lalu lintas jaringan.
```
# Menjalankan skrip
./traffic.sh
```
4. Setelah skrip berjalan selama beberapa saat, proses dihentikan (dengan Ctrl + C di terminal Manwe dan tombol Stop di Wireshark).

#### 3. Langkah Analisis: Menerapkan Display Filter
Konsep:
Untuk fokus pada lalu lintas yang relevan, display filter di Wireshark digunakan. Filter ini akan menyaring jutaan paket dan hanya menampilkan yang sesuai dengan kriteria, yaitu paket di mana Manwe adalah pengirim atau penerima.

Implementasi di Wireshark:
Pada baris filter, diterapkan aturan berikut untuk mengisolasi semua trafik dari dan ke Manwe (dengan asumsi IP Manwe adalah 10.71.1.3):

`ip.src == 10.71.1.3 or ip.dst == 10.71.1.3`
- Catatan: Filter ini memiliki fungsi yang sama persis dengan filter yang lebih singkat, yaitu ip.addr == 10.71.1.3.

**Hasil Akhir**:
Hasilnya adalah tampilan di Wireshark yang hanya berisi paket-paket di mana Manwe adalah pengirim atau penerima. Hasil capture ini kemudian dapat disimpan sebagai bukti pengerjaan.
