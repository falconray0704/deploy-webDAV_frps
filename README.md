# deploy-webDAV_frps
Deploy frps for a webDAV in LAN.

# Refer to:
* https://github.com/dgraziotin/docker-nginx-webdav-nononsense/tree/main
  Tag: 1.27.1

* https://github.com/tborychowski/self-hosted-cookbook
* https://github.com/tborychowski/self-hosted-cookbook/blob/master/apps/cloud/nginx-webdav.md

If you want to customize the location of deploment, configure following variables in `.env`:

* `INSTALL_ROOT_PATH` :  Parent path for deployment.
* `SERVER_NAME`: Directory for deployment at INSTALL_ROOT_PATH .

```bash
./run.sh 
Usage:
./run.sh -c <cmd> -l "<item list>"
eg:
./run.sh -c deploy -l "frps_webDAV"
Supported cmd:
deploy
Supported items:
frps_webDAV
```

