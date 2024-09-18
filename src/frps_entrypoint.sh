#!/bin/sh

set -o nounset
set -o errexit

which frps

ls -al /etc/frp/frps.toml
cat /etc/frp/frps.toml
/usr/bin/frps -c /etc/frp/frps.toml

