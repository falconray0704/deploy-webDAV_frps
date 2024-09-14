#!/bin/bash

set +x

. ./echo_color.lib
. ./file.lib


CURRENT_DIR=$(current_dir)
echoY "Current dir name:${CURRENT_DIR}"

PARENT_PATH=$(parent_path)
echoY "Parent path:${PARENT_PATH}"

