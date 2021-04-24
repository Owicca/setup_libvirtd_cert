#!/bin/bash

certtool --generate-privkey > cakey.pem

cat <<EOF > ca.info
cn = $1
ca
cert_signing_key
EOF

certtool --generate-self-signed --load-privkey cakey.pem \
  --template ca.info --outfile cacert.pem

sudo -u root cp cacert.pem /etc/pki/CA/

$(cd server && bash server_setup_cert.sh "$1")
$(cd client && bash client_setup_cert.sh "$1")
