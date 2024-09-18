#!/bin/bash

set -o nounset
set -o errexit
# trace each command execute, same as `bash -v myscripts.sh`
#set -o verbose
# trace each command execute with attachment infomations, same as `bash -x myscripts.sh`
#set -o xtrace

#set -o
set -e
#set -x

source .env

timestamp()
{
    TIMESTAMP="$(date +%Y%m%d-%H%M%S)" 
    echo ${TIMESTAMP}
}
TIME=$(timestamp)


SELFSIGNED_CERTS_DIR="${SELFSIGNED_CERTS_DIR}_${TIME}"
mkdir -p ${SELFSIGNED_CERTS_DIR}


pushd ${SELFSIGNED_CERTS_DIR}

# root CA
#openssl rand -out ${HOME}/.rnd -hex 256

cat > frp.cnf << EOF
[ ca ]
default_ca = CA_default
[ CA_default ]
x509_extensions = usr_cert
[ req ]
default_bits        = 2048
default_md          = sha256
default_keyfile     = privkey.pem
distinguished_name  = req_distinguished_name
attributes          = req_attributes
x509_extensions     = v3_ca
string_mask         = utf8only
[ req_distinguished_name ]
[ req_attributes ]
[ usr_cert ]
basicConstraints       = CA:FALSE
nsComment              = "OpenSSL Generated Certificate"
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid,issuer
[ v3_ca ]
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always,issuer
basicConstraints       = CA:true
EOF


openssl genrsa -out rootCA.key 2048
openssl req -x509 -new -nodes -key rootCA.key -subj "/CN=${CA_SERVER_DOMAIN}" -days 36500 -out rootCA.crt

mkdir frps frpc

# frps crt
openssl genrsa -out frps/server.key 2048


openssl req -new -sha256 -key frps/server.key \
    -subj "/C=XX/ST=DEFAULT/L=DEFAULT/O=DEFAULT/CN=${FRPS_SERVER_DOMAIN}" \
    -reqexts SAN \
    -config <(cat frp.cnf <(printf "\n[SAN]\nsubjectAltName=DNS:localhost,IP:${FRPS_SERVER_IP},DNS:frps.${FRPS_SERVER_DOMAIN}")) \
    -out frps/server.csr

openssl x509 -req -days 3650 -sha256 \
	-in frps/server.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial \
	-extfile <(printf "subjectAltName=DNS:localhost,IP:${FRPS_SERVER_IP},DNS:frps.${FRPS_SERVER_DOMAIN}") \
	-out frps/server.crt




# frpc crt

openssl genrsa -out frpc/client.key 2048

openssl req -new -sha256 -key frpc/client.key \
    -subj "/C=XX/ST=DEFAULT/L=DEFAULT/O=DEFAULT/CN=${FRPS_SERVER_DOMAIN}" \
    -reqexts SAN \
    -config <(cat frp.cnf <(printf "\n[SAN]\nsubjectAltName=DNS:frpc.${FRPS_SERVER_DOMAIN}")) \
    -out frpc/client.csr

openssl x509 -req -days 365 -sha256 \
    -in frpc/client.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial \
	-extfile <(printf "subjectAltName=DNS:frpc.${FRPS_SERVER_DOMAIN}") \
	-out frpc/client.crt

popd

tree -a ${SELFSIGNED_CERTS_DIR}

BACKUP_PATH=backups
mkdir -p ${BACKUP_PATH}

cp -a ${SELFSIGNED_CERTS_DIR} ${BACKUP_PATH}/


rm -rf ${CERTS_DIR}
rm -rf ${CERTS_DIR}_client


mkdir -p ${CERTS_DIR}
cp ${SELFSIGNED_CERTS_DIR}/frps/server.crt ${CERTS_DIR}/
cp ${SELFSIGNED_CERTS_DIR}/frps/server.key ${CERTS_DIR}/
cp ${SELFSIGNED_CERTS_DIR}/rootCA.crt ${CERTS_DIR}/

tree -a ${CERTS_DIR}


mkdir -p ${CERTS_DIR}_client
cp ${SELFSIGNED_CERTS_DIR}/frpc/client.crt "${CERTS_DIR}_client"/
cp ${SELFSIGNED_CERTS_DIR}/frpc/client.key "${CERTS_DIR}_client"/
cp ${SELFSIGNED_CERTS_DIR}/rootCA.crt "${CERTS_DIR}_client"/

tar -zcf ${CERTS_DIR}_client_${TIME}.tar.gz ${CERTS_DIR}_client

tree -a "${CERTS_DIR}_client"

