# Script untuk menginstal alat-alat dasar di root:Eru

apt update && apt install iptables
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 10.71.0.0/16
echo nameserver 192.168.122.1 > /etc/resolv.conf

# Ping untuk mengecek apakah eru connect ke internet
ping google.com -c [jumlah_tes]
