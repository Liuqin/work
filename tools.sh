#!/bin/bash
#menu.sh

menu() {
  source ~/.bashrc
  echo "================================="
  echo "选择题:"
  echo "(0) 更新系统"
  echo "(1) 安装docker"
  echo "(2) 安装docker-compose"
  echo "(3) 安装Bt"
  echo "(4) 安装redis集群"
  echo "(5) 安装ruby"
  echo "(6) Docker安装单机Redis"

  echo "(9) Exit Menu"
  echo "================================"
  read input
  if [ $input != "9" -a $input != "0" -a $input != "1" -a $input != "2" -a $input != "3" -a $input != "4" -a $input != "5" -a $input != "6" ]; then
    menu
  fi

  case $input in
  0)
    echo "更新系统" ?
    sleep 1
    read -s -n1 -p "更新系统?(y/n)?:.... "
    if [ $REPLY == "y" ]; then
      yum update -y
    fi
    menu
    ;;
  1)
    echo "安装docker"?
    sleep 1
    read -s -n1 -p "安装docker(y/n)? ... "
    if [ $REPLY == "y" ]; then

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

    fi

    menu
    ;;
  2)
    echo "安装docker-compose"
    sleep 1
    read -s -n1 -p "安装docker-compose'(y/n)? ... "
    if [ $REPLY == "y" ]; then

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

      echo '查看docker-compose版本'
      docker-compose --version

    fi

    menu
    ;;
  3)
    echo "安装宝塔BT"
    sleep 1
    read -s -n1 -p "安装宝塔BT(y/n)? ... "
    if [ $REPLY == "y" ]; then
      yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh
    fi
    menu
    ;;
  4)
    # echo 安装redis 集群
    sleep 1
    read -s -n1 -p "安装redis 集群(y/n)? ... "
    if [ $REPLY == "y" ]; then

      echo '-------------------------------------------------------------'
      echo '              安装  redis 集群'
      echo '-------------------------------------------------------------'
      yum -y install tree

      # 在 /home 目录下创建redis-cluster 文件夹
      rm -rf /home/redis-cluster
      docker rm -f redis-6380
      docker rm -f redis-6381
      docker rm -f redis-6382
      docker rm -f redis-6383
      docker rm -f redis-6384
      docker rm -f redis-6385

      mkdir -p /home/redis-cluster
      cd /home/redis-cluster

      # 清空 redis-cluster.conf文件中
      cat /dev/null >redis-cluster.conf
      rm -f redis-cluster.conf

      yum -y install tree
      # 在 /home 目录下创建redis-cluster 文件夹
      mkdir -p /home/redis-cluster
      cd /home/redis-cluster
      # 清空 redis-cluster.conf文件中
      cat /dev/null >redis-cluster.conf
      # 把下列信息写入redis-cluster.conf文件中

      cat >redis-cluster.conf <<EOF
            port ${PORT}
            cluster-enabled yes
            cluster-config-file nodes.conf
            cluster-node-timeout 5000
            appendonly yes
EOF

      # 在 /home/redis-cluster 目录下生成conf和data目录，并生成配置文件
      for port in $(seq 6380 6385); do
        mkdir -p ./${port}/conf && PORT=${port} envsubst <./redis-cluster.conf >./${port}/conf/redis.conf && mkdir -p ./${port}/data
      done
      # tree命令查看目录(如果命令不存在，执行安装命令：yum -y install tree)
      tree

      # 创建6个redis容器
      for port in $(seq 6380 6385); do
        docker run --net=host --name=redis-${port} -v $(pwd)/${port}/conf/redis.conf:/usr/local/etc/redis/redis.conf -d redis:latest redis-server /usr/local/etc/redis/redis.conf
      done
      echo '-------------------------------------------------------------'
      echo '              启动  redis 集群'
      echo '-------------------------------------------------------------'
      echo '安装redis 中'
      # 如果没有ruby，请执行 yum -y install ruby
      yum -y install ruby
      gem install redis

      echo ''
      # 启动集群
      myiplist=''
      for port in $(seq 6380 6385); do
        myiplist=${myiplist}' '"127.0.0.1:"${port}
      done
      echo "当前节点:"
      echo $myiplist
      ruby $(echo $rb) create --replicas 1 $(echo ${myiplist})
    fi
    menu
    ;;
  5)
    echo "安装ruby"
    sleep 1
    read -s -n1 -p "安装ruby(y/n)? ... "
    if [ $REPLY == "y" ]; then
      yum -y install ruby
      gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
      gem sources -a http://mirrors.aliyun.com/rubygems/
      sh ./ruby.sh
      sleep 1
      echo '安装redis 中'
      yum install -y rubygems
      # 通过locate或find命令查找 `redis-trib.rb`文件位置，
      rvm install 2.5.1
      rvm use 2.5.1 --default
      source /usr/local/rvm/scripts/rvm
      gem uninstall redis
      gem install redis
      yum install -y rubygems
      # 创建软连接到bin目录
      echo '系统 redis-trib.rb 路径:'
      rb=$(find / -name redis-trib.rb)
      echo $rb
      echo ''
    fi
    menu
    ;;
  6)
    echo "Docker安装单机Redis"
    sleep 1
    ps aux | grep java

    menu
    ;;
  9)
    exit
    ;;
  esac
}
menu
