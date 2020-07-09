#!/bin/bash
cd zk
echo 'zk 集群启动本地的 2181, 2182, 2183 端口 '
#docker pull zookeeper
docker-compose down -v
COMPOSE_PROJECT_NAME=zk_cluster docker-compose up -d

read -p "服务器地址,默认127.0.0.1:" local_ip
echo 'local_ip:' $local_ip
echo '服务器地址:'$local_ip
if [ ! -n "$local_ip" ]; then
  echo "使用默认127.0.0.1"
  local_ip = 127.0.0.1
  echo $local_ip
else
  echo $local_ip
fi
docker rm zkui
docker run -d --name zkui -p 9090:9090 -e ZKUI_ZK_SERVER=$(echo $local_ip):2181 qnib/zkui
echo 'zui 启动在9090 端口'
cd /work
