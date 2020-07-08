#!/bin/bash
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
