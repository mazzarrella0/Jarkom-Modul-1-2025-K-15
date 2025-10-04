# untuk menyimpan konfig di router agar ketika di restart tidak hilang adalah dengan memodifikasi config eru menjadi seperti ini
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

# untuk menyimpan konfig di client agar ketika di restart tidak hilang adalah dengan memodifikasi config manwe,melkor, dll menjadi seperti ini
auto eth0
iface eth0 inet static
	address 10.71...
	netmask 255.255.255.0
	gateway 10.71...

up echo nameserver 192.168.122.1 > /etc/resolv.conf

# sehingga ketika di restart dan masuk baik router serta client, confignya tidak hilang