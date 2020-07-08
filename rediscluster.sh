#!/bin/bash

sleep 1
yum install gawk -y
read -p "内网地址,默认127.0.0.1:" local_ip
echo 'local_ip:' $local_ip
echo '内网地址:'$local_ip
if [ ! -n "$local_ip" ]; then
  echo "使用默认127.0.0.1"
  local_ip=127.0.0.1
  echo $local_ip
else
  echo $local_ip
fi
sleep 1
yum -y install gcc
yum -y install libc

clear
sleep 1
if [ -f "/work/redis-3.2.0.tar.gz" ]; then
  echo "文件存在"
else
  echo "文件不存在"
  wget https://mirrors.huaweicloud.com/redis/redis-3.2.0.tar.gz
  sleep 1
  echo 'redis-3.2.0.tar.gz 下载完成'
fi

tar -zxvf redis-3.2.0.tar.gz
sudo rm -rf /usr/local/redis
mv redis-3.2.0 /usr/local/redis
cd /usr/local/redis/
echo ''
echo '试图编译安装'
make && make install
sleep 1
cd /work
clear

echo '-------------------------------------------------------------'
echo '              安装  redis 集群'
echo '-------------------------------------------------------------'
yum -y install tree

# 在 /home 目录下创建redis-cluster 文件夹
rm -rf /home/redis-cluster
rm -rf /home/redis-cluster/
docker rm -f redis-6381
docker rm -f redis-6382
docker rm -f redis-6383
docker rm -f redis-6384
docker rm -f redis-6385
docker rm -f redis-6386
mkdir -p /home/redis-cluster
cd /home/redis-cluster
# 清空 redis-cluster.conf文件中
cat /dev/null >redis-cluster.conf
rm -f redis-cluster.conf
yum -y install tree
# 在 /home 目录下创建redis-cluster 文件夹
mkdir -p /home/redis-cluster
cd /home/redis-cluster
rm -f redis-cluster.tmpl
cp /work/redis-cluster.tmpl ./redis-cluster.tmpl

node_var=$(date +%N | md5sum | cut -c 1-8)
echo $node_var
echo '---------------------------'
for port in $(seq 6381 6386); do
  echo $node_var
  mkdir -p ./${port}/conf &&
    PORT=${port} ip=${local_ip} nodes=${node_var} envsubst <./redis-cluster.tmpl >./${port}/conf/redis.conf &&
    mkdir -p ./${port}/data
done
tree
# 创建6个redis容器
for port in $(seq 6381 6386); do
  #      docker run -d -it --restart=always -p ${port}:${port} -p 1${port}:1${port} -v /home/redis-cluster/${port}/conf/redis.conf:/usr/local/etc/redis/redis.conf -v /home/redis-cluster/${port}/data:/data --name redis-${port} --sysctl net.core.somaxconn=1024 redis redis-server /usr/local/etc/redis/redis.conf
  docker run -d -it --privileged=true --restart=always -p ${port}:${port} -p 1${port}:1${port} -v /home/redis-cluster/${port}/conf/redis.conf:/usr/local/etc/redis/redis.conf -v /home/redis-cluster/${port}/data:/data --name redis-${port} --sysctl net.core.somaxconn=1024 redis redis-server /usr/local/etc/redis/redis.conf

done
echo '-------------------------------------------------------------'
echo '              启动  redis 集群'
echo '-------------------------------------------------------------'
echo '安装redis 中'
# 如果没有ruby，请执行 yum -y install ruby
yum -y install ruby
echo 'ruby重装redis'
gem install redis
echo ''
# 启动集群
myiplist=''
for port in $(seq 6381 6386); do
  node_s=' '${local_ip}':'${port}
  myiplist=${myiplist}${node_s}
done
echo "当前节点:"
echo $myiplist
echo '等待服务启动'
sleep 1
docker ps -a
echo '等待服务启动'
sleep 1
echo '等待服务启动'
if [ -f "/usr/bin/redis-trib.rb" ]; then
  echo "存在命令"
else
  ln -s /usr/local/redis/src/redis-trib.rb /usr/bin/redis-trib.rb
fi

sleep 1
sleep 1
sleep 1
echo '如果下面命令失败，手动执行:'
echo ' redis-trib.rb create --replicas 1 ' $myiplist
redis-trib.rb create --replicas 1 $(echo $myiplist)

sleep 1
echo '常用检查修复节点命令：'
echo 'redis-trib.rb fix '${local_ip}':6383'
echo 'redis-trib.rb check '${local_ip}':6383'
