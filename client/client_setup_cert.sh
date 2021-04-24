#!/bin/bash

certtool --generate-privkey > clientkey.pem

cat <<EOF > client.info
country = COUNTRY
state = STATE
locality = LOCALITY
organization = $1
cn = $1
tls_www_client
encryption_key
signing_key
EOF

certtool --generate-certificate --load-privkey clientkey.pem \
  --load-ca-certificate ../cacert.pem --load-ca-privkey ../cakey.pem \
  --template client.info --outfile clientcert.pem

if [ ! -d $HOME/.pki/libvirt/ ];then
  sudo -u root mkdir -p $HOME/.pki/libvirt/
fi
sudo -u root cp clientkey.pem /etc/pki/libvirt/private/ && \
  sudo -u root cp clientcert.pem /etc/pki/libvirt/

if [ ! -d $HOME/.pki/libvirt/ ];then
  mkdir -p $HOME/.pki/libvirt/
fi
cp clientkey.pem $HOME/.pki/libvirt/ && \
  cp clientcert.pem $HOME/.pki/libvirt/
