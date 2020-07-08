#!/bin/bash
echo "部分单机服务"
sleep 1
echo "重置Docker的Web管理器:"
docker rm -f liuqin-dockerui
echo '请不要慌'
docker run -d -p 5999:9000 -m 300M --name liuqin-dockerui --restart=always -v /var/run/docker.sock:/var/run/docker.sock abh1nav/dockerui:latest
echo '5999 开启了dockerui 服务'

## setup redis_single
sleep 1
read -p "是否重装Redis(y/n)?:" reinstall_redis
echo 'reinstall_redis: ' $reinstall_redis
sleep 1
if [ $reinstall_redis == "y" ]; then
  chmod +x redis_single.sh
  sh redis_single.sh
fi

## setup minio
sleep 1
read -p "是否重装Minio(y/n)?:" reinstall_minio
echo 'reinstall_minio: ' $reinstall_minio
sleep 1
if [ $reinstall_minio == "y" ]; then
  chmod +x minio.sh
  sh minio.sh
fi

## setup zookeeper_cluster
sleep 1
read -p "是否重装zk集群(y/n)?:" reinstall_zkcluster
echo 'reinstall_zkcluster: ' $reinstall_zkcluster
sleep 1
if [ $reinstall_zkcluster == "y" ]; then
  chmod +x zkcluster.sh
  sh zkcluster.sh
fi
