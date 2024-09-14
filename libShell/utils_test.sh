#!/bin/bash

set +x

. ./echo_color.lib
. ./utils.lib


list_of_fruits="banana pear apple strawberry lime"

if exists_in_list "$list_of_fruits" " " pear; then
    echoG "pear is in the list: ${list_of_fruits}"
else
    echoR "pear is not in the list: ${list_of_fruits}"
fi

if exists_in_list "$list_of_fruits" " " watermelon; then
    echoG "watermelon is in the list: ${list_of_fruits}"
else
    echoR "watermelon is not in the list: ${list_of_fruits}"
fi

