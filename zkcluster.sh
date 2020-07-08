#!/bin/bash
cd zk
echo 'zk 集群启动本地的 2181, 2182, 2183 端口 '
docker pull zookeeper
docker-compose stop zk_cluster
COMPOSE_PROJECT_NAME=zk_cluster docker-compose up -d
cd /work
