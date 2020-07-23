#!/bin/bash

echo "安装docker-compose"
echo '-------------------------------------------------------------'
echo '              pip 安装 docker-compose'
echo '-------------------------------------------------------------'
yum install python-pip -y
yum -y install epel-release
yum install python-pip -y
pip install --upgrade pip
yum install -y python36 python36-devel
python3 -m pip install --upgrade pip
pip3 uninstall docker-compose
pip3 install docker-compose
sudo chmod +x /usr/local/bin/docker-compose
ln -s  /usr/local/bin/docker-compose /usr/bin/docker-compose
echo '查看docker-compose版本'
docker-compose --version
