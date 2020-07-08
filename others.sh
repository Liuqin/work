#!/bin/bash
echo "部分单机服务"
sleep 1
echo "重置Docker的Web管理器:"
docker rm -f liuqin-dockerui
echo '请不要慌'
docker run -d -p 5999:9000 -m 300M --name liuqin-dockerui --restart=always -v /var/run/docker.sock:/var/run/docker.sock abh1nav/dockerui:latest
echo '5999 开启了dockerui 服务'
sleep 1

read -p "是否重装Redis(y/n)?:" reinstall_redis
echo 'reinstall_redis: ' $reinstall_redis
sleep 1
if [ $reinstall_redis == "y" ]; then

  read -p "port:" port
  echo 'port:' $port
  if [ ! -n "$port" ]; then
    echo "使用默认端口6380"
    port=6380
    echo $port
  else
    echo $port
  fi

  read -p "password:" password
  echo 'password:' $password
  if [ ! -n "$password" ]; then
    echo "使用空密码"
  else
    echo $password
  fi
  docker rm -f liuqin-redis
  echo '请不要慌'
  if [ ! -n "$password" ]; then
    docker run -it --restart=always --name liuqin-redis -p $port:6379 -d redis
    echo $port'开启了单机redis服务'
  else
    docker run -it --restart=always --name liuqin-redis -p $port:6379 -d redis --requirepass $password
    echo $port'开启了单机redis服务'
  fi
  sleep 1
  echo 'completed!'
fi

sleep 1
read -p "是否重装Minio(y/n)?:" reinstall_minio
echo 'reinstall_minio: ' $reinstall_minio
sleep 1
if [ $reinstall_minio == "y" ]; then
  docker rm -f liuqin-minio
  echo '请不要慌'
  read -p "minioport:" minioport
  echo 'minioport:' $minioport
  if [ ! -n "$minioport" ]; then
    echo "使用默认端口8742"
    minioport=8742
    echo $minioport
  else
    echo $minioport
  fi
  sudo rm -rf /minio/data
  sudo mkdir -p /minio/data
  sudo mkdir -p /minio/config
  docker run -d -p $minioport:9000 --restart=always --name liuqin-minio -e "MINIO_ACCESS_KEY=liuqin" -e "MINIO_SECRET_KEY=liuqin0111" -v /minio/data:/data -v /minio/config:/root/.minio minio/minio server /data
  echo $minioport'开启了minio 服务'
  echo 'MINIO_ACCESS_KEY:liuqin'
  echo 'MINIO_SECRET_KEY:liuqin0111'
  echo 'completed!'
fi
