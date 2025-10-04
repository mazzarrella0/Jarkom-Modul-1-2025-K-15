#!/bin/bash

set -e

# di ulmo login ainur

wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=11ra_yTV_adsPIXeIPMSt0vrxCBZu0r33' -O cuaca.zip

apt-get update > /dev/null
apt-get install -y ftp

ftp -n 10.71.1.1 <<EOF
user $FTP_USER $FTP_PASS
binary
put cuaca.zip
bye
EOF