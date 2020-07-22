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
  echo "(6) 部分单机服务"
  echo "(7) gitea服务"
  echo "(9) Exit Menu"
  echo "================================"
  read input
  if [ $input != "9" -a $input != "0" -a $input != "1" -a $input != "2" -a $input != "3" -a $input != "4" -a $input != "5" -a $input != "6" -a $input != "7" ]; then
    menu
  fi

  case $input in
  0)
    echo "更新系统" ?
    sleep 1
    read -s -n1 -p "更新系统?(y/n)?:.... "
    if [ $REPLY == "y" ]; then
      yum install -y java
      chmod +x mvn_install.sh
      sh mvn_install.sh
      yum update -y
    fi
    menu
    ;;
  1)
    chmod +x docker.sh
    sh docker.sh
    menu
    ;;
  2)
    chmod +x docker_compose.sh
    sh docker_compose.sh
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
    chmod +x rediscluster.sh
    sh rediscluster.sh
    menu
    ;;
  5)
    echo "安装ruby"
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
    menu
    ;;
  6)
    chmod +x others.sh
    sh others.sh
    menu
    ;;
  7)
    chmod +x gitea.sh
    sh gitea.sh
    menu
    ;;
  9)
    exit
    ;;
  esac
}
menu
