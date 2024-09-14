#!/bin/bash

# refer to:
# https://www.cnblogs.com/kevingrace/p/11753294.html

#set -o
set -e
#set -x


usage_func()
{
    echo "Usage:"
    echo './args_test.sh -i "172.16.60.10,172.16.60.11,172.16.60.12,172.16.60.13" -p "8080,8080,8088,8099"'

    echo -e "OPTIONS:\n-a:Project number(required)\n-b:module name(option, default empty string)\n-n:ZooKeeper server count(option, default 3)"
    echo -e "-i:ZooKeeper server IP list (required, split with \",\""
    echo -e "-p:Client-Port (option, default is 2181, multi ports are splited by \",\")"
}


no_args="true"
while getopts "i:p:" opts
do
    case $opts in
        i)
              # ip list
              NODE_IP_LIST=$OPTARG
              ;;
        p)
              # port list
              NODE_PORT_LIST=$OPTARG
              ;;
        :)
            echo "The option -$OPTARG requires an argument."
            exit 1
            ;;
        ?)
            echo "Invalid option: -$OPTARG"
            usage_func
            exit 2
            ;;
        *)    #unknown error?
              echoR "unkonw error."
              usage_func
              exit 1
              ;;
    esac
    no_args="false"
done

[[ "$no_args" == "true" ]] && { usage_func; exit 1; }
#[ $# -lt 1 ] && echoR "Invalid args count:$# " && usage_func && exit 1


 
NODE_NUM=`echo ${NODE_IP_LIST}|awk -F"," '{print NF}'`
for ((i=1;i<=${NODE_NUM};i++)); do
    eval NODE_IP='`echo ${NODE_IP_LIST}|awk -F, "{ print $"$i" }"`'
    eval NODE_PORT='`echo ${NODE_PORT_LIST}|awk -F, "{ print $"$i" }"`'
 
    echo "http://ke_beta.pro.com/gateway/servty?/address=${NODE_IP}:${NODE_PORT}"
done


