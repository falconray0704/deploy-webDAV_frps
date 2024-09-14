#!/bin/bash

# refer to:
# https://www.cnblogs.com/kevingrace/p/11753294.html

#set -o
set -e
#set -x

. ./echo_color.lib
. ./network.lib


INTERFACE_NAME="enx9cebe8105d32"
IP=$(get_iether_IP4 $INTERFACE_NAME)
echoY ${IP}

MAC=$(get_iether_MAC $INTERFACE_NAME)
echoY ${MAC}

${DOWNLOAD_RESOURCE} -o test.png https://www.baidu.com/img/flexible/logo/pc/result.png

