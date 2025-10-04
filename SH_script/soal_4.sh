# masuk ke salah satu client dan gunakan command ini
root@Client:~# echo "nameserver 192.168.122.1" > /etc/resolv.conf

# Lalu cek koenksinya, apabila ada info pengiriman dan tidak ada packet loss, maka client berhasil connect ke internet
root@Client:~# ping google.com -c 2