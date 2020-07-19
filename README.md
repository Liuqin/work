#搭建Redis 集群 和其他服务



搭建Redis 集群 和其他服务
安装 redis 集群 经常遇到问题，写一个脚本给 大家用：

1，首先 拉我的 脚本

    git clone https://www.github.com/liuqin/work.git

    cd /work

    chmod +x tools.sh

    sh tools.sh

###
![Image text](./images/菜单.png)
###
一般情况下 建议优先安装 ruby 服务，由于有个github 文件有点大，所以，第一个ruby 相对慢一点

###
后面可以安装 docker docker-compose ，有服务的孩童跳过

后面安装 BT，你就有界面了

![Image text](./images/bt.png)
###
BT 我就不讲了，你们可以进去 设置自己的端口 和服务

###
后面去设置我们的集群

###
我是单机集群6个本地节点，选择4 ，多机器集群的孩子 自己改一下脚本设置

![Image text](./images/单机集群.png)
###
系统让你填写 ip ，建议填写 外网ip 或者 内置ip

###
不建议 127.0.0.1 ，容易出故障

###

一路向下，系统会拉redis 镜像和 ruby 重装一个 reds 组件包

###

如果启动出现错误，一般不会出错，

###只有出错才执行 提示的命令，没有出错不用动

![Image text](./images/yes.png)
###

输入yes 同意

image
###最后看到

![Image text](./images/安装成功.png)

