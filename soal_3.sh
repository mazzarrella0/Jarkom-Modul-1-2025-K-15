# login menjadi salah satu client (melkor) dulu, lalu hubungkan dengan internet
echo nameserver 192.168.122.1 > /etc/resolv.conf

# ping -c [berapa_kali] [ip_prefix][ip client]
ping -c 4 10.71.2.2 #Varda

# Jika muncul pengiriman sinyal maka sudah berhubung antar client