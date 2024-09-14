#!/bin/bash

set +x
set -e

export LIBSHELL_ROOT_PATH=${PWD}
. .env_setup
. ./echo_color.lib
. ./sysEnv.lib


IP=$(get_iether_IP4 enp8s0)
MAC=$(get_iether_MAC enp8s0)
echoY ${IP}
echoY ${MAC}

echoY "os distributor: ${OSENV_DIST_ID}"
echoY "os distribution number: ${OSENV_DIST_REL_NUM}"
echoY "os distribution name: ${OSENV_DIST_CODENAME}"
echoY "os package management: ${OSENV_PKG_MANAGE}"
echoY "os kernel name: ${OSENV_KERNEL}"
echoY "os arch: ${OSENV_OS_CPU_ARCH}"

echo ""

echoY "docker os: ${OSENV_DOCKER_OS}"
echoY "docker cpu arch: ${OSENV_DOCKER_CPU_ARCH}"
echoY "docker tag cpu arch: ${OSENV_DOCKER_TAG_CPU_ARCH}"

VAL_ARM_VERSION=$(arm_version)
if [ -z ${VAL_ARM_VERSION} ]
then
    echoR "CPU arch ${VAL_ARM_VERSION} not ARM!!!"
else
    echoY "CPU arm version: ${VAL_ARM_VERSION}"
fi


if [ $(is_Ubuntu_x86_64_bionic) -eq 1 ] || \
    [ $(is_Pi3BP_Raspbian_aarch64_Debian_bullseye) -eq 1 ] || \
    [ $(is_Pi3BP_Raspbian_armv7l_Debian_bullseye) -eq 1 ]
then
    echoY "Platform info: OSENV_DIST_ID == ${OSENV_DIST_ID}, OSENV_DIST_CODENAME == ${OSENV_DIST_CODENAME}, OSENV_OS_CPU_ARCH == ${OSENV_OS_CPU_ARCH}"
else
    echoR "Unsupported Platform : OSENV_DIST_ID == ${OSENV_DIST_ID}, OSENV_DIST_CODENAME == ${OSENV_DIST_CODENAME}, OSENV_OS_CPU_ARCH == ${OSENV_OS_CPU_ARCH}"
fi

is_root_func
echoG "Runing as root."
