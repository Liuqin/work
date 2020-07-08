#!/bin/bash

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
