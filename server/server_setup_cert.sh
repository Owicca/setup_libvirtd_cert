#!/bin/bash

certtool --generate-privkey > serverkey.pem

cat <<EOF > server.info
organization = $1
cn = $1
dns_name = $1
ip_address = $1
tls_www_server
encryption_key
signing_key
EOF

certtool --generate-certificate --load-privkey serverkey.pem \
  --load-ca-certificate ../cacert.pem --load-ca-privkey ../cakey.pem \
  --template server.info --outfile servercert.pem

if [ ! -d $HOME/.pki/libvirt/ ];then
  sudo -u root mkdir /etc/pki/libvirt/private/
fi
sudo -u root cp serverkey.pem /etc/pki/libvirt/private/ && \
  sudo -u root cp servercert.pem /etc/pki/libvirt/
