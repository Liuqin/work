echo '中国地区快速安装 k3sup 工具'
echo '安装k3s master节点，指定使用docker容器'
curl -sfL https://docs.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -s - server --docker
echo '查看master 节点信息'
cat /var/lib/rancher/k3s/server/node-token
token=$(cat /var/lib/rancher/k3s/server/node-token)
echo '测试获取的token: '$token
echo '确认节点信息:'
kubectl get node -o wide
echo '安装worker节点:'
curl -sfL https://docs.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn K3S_URL=https://localhost:6443 K3S_TOKEN=$(echo $token)  INSTALL_K3S_EXEC="--docker" sh -