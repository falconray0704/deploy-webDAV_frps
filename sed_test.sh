#!/bin/bash

set -o nounset
set -o errexit
# trace each command execute, same as `bash -v myscripts.sh`
#set -o verbose
# trace each command execute with attachment infomations, same as `bash -x myscripts.sh`
#set -o xtrace


. ./sed.lib

SRC_PATH=$PWD
echo "SRC_PATH:${SRC_PATH}"
DST_PATH=$(get_sed_path ${SRC_PATH})
echo "DST_PATH:${DST_PATH}"

#sed -i "s/path_certbot-etc/$(sed_path ${CERTBOT_ETC_DATA_PATH})/" ./docker-compose.yml

