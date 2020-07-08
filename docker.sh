#!/bin/bash

echo "安装docker"
sleep 1
echo '-------------------------------------------------------------'
echo '              docker 清理旧版本'
echo '-------------------------------------------------------------'
systemctl stop docker
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine
find /etc/systemd -name '*docker*' -exec rm -f {} \;
find /etc/systemd -name '*docker*' -exec rm -f {} \;
find /lib/systemd -name '*docker*' -exec rm -f {} \;
rm -rf /var/lib/docker #删除以前已有的镜像和容器,非必要
rm -rf /var/run/docker
sudo rm /usr/local/bin/docker-compose
echo '-------------------------------------------------------------'
echo '              开始安装docker'
echo '-------------------------------------------------------------'
sudo yum install -y yum-utils \ device-mapper-persistent-data \ lvm2
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
sudo yum makecache fast
sudo yum install docker-ce -y
sudo yum install epel-release -y
echo '-------------------------------------------------------------'
echo '              重启docker'
echo '-------------------------------------------------------------'
systemctl daemon-reload
sudo service docker restart
systemctl enable docker.service
docker -v
