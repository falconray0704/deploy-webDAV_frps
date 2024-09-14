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

export LIBSHELL_ROOT_PATH=${PWD}
. ${LIBSHELL_ROOT_PATH}/echo_color.lib
. ${LIBSHELL_ROOT_PATH}/utils.lib
. ${LIBSHELL_ROOT_PATH}/sysEnv.lib

# Checking environment setup symbolic link and its file exists
if [ -L ".env_setup" ] && [ -f ".env_setup" ]
then
#    echoG "Symbolic .env_setup exists."
    . ./.env_setup
else
    echoR "Setup environment informations by making .env_setup symbolic link to specific .env_setup_xxx file(eg: .env_setup_amd64_ubt_1804) ."
    exit 1
fi



SUPPORTED_CMD="get,clean,build,release"
SUPPORTED_TARGETS="source,doc"

EXEC_CMD=""
EXEC_ITEMS_LIST=""

get_source()
{
    echoY "Getting source..."
}

clean_source()
{
    echoY "Cleaning source..."
}

build_source()
{
    echoY "Building source..."
}

release_source()
{
    echoY "Release source..."
}

get_doc()
{
    echoY "Getting doc..."
}

clean_doc()
{
    echoY "Cleaning doc..."
}

build_doc()
{
    echoY "Building doc..."
}

release_doc()
{
    echoY "Release doc..."
}

usage_func()
{

    echoY "Usage:"
    echoY './run_templete.sh -c <cmd> -l "<item list>"'
    echoY "eg:\n./run_templete.sh -c get -l \"source,doc\""
    echoY "eg:\n./run_templete.sh -c clean -l \"source,doc\""
    echoY "eg:\n./run_templete.sh -c build -l \"source,doc\""
    echoY "eg:\n./run_templete.sh -c release -l \"source,doc\""

    echoC "Supported cmd:"
    echo "${SUPPORTED_CMD}"
    echoC "Supported items:"
    echo "${SUPPORTED_TARGETS}"
    
}

no_args="true"
while getopts "c:l:" opts
do
    case $opts in
        c)
              # cmd
              EXEC_CMD=$OPTARG
              ;;
        l)
              # items list
              EXEC_ITEMS_LIST=$OPTARG
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


case ${EXEC_CMD} in
    "get")
        get_items ${EXEC_CMD} ${EXEC_ITEMS_LIST}
        ;;
    "clean")
        clean_items ${EXEC_CMD} ${EXEC_ITEMS_LIST}
        ;;
    "build")
        build_items ${EXEC_CMD} ${EXEC_ITEMS_LIST}
        ;;
    "release")
        release_items ${EXEC_CMD} ${EXEC_ITEMS_LIST}
        ;;
    "*")
        echoR "Unsupport cmd:${EXEC_CMD}"
        ;;
esac



