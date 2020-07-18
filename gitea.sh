#!/bin/bash

echo '-------------------------------------------------------------'
echo '              重新安装gitea 服务'
echo '-------------------------------------------------------------'
docker pull gitea/gitea:latest
sudo rm -rf /var/lib/gitea
sudo mkdir -p /var/lib/gitea
docker rm -f liuqin-gitea
docker run -itd --privileged=true  --restart=always  --name=liuqin-gitea -p 10022:22 -p 6001:3000 -v /var/lib/gitea:/data gitea/gitea:latest
echo '在6001 搭建了快速高性能代码仓库'