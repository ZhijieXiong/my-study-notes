## docker

##### 安装

- apt-get intall curl

```shell
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

- 拉取镜像，创建容器（第一次创建会启动容器），每个容器需要取一个唯一的名字，删除容器需要先停止容器

##### 镜像

- 镜像
  - docker images
    - 查看本地镜像
  - docker pull <name>:<tag>
    - 拉取镜像
- 容器
  - docker run
    - 创建容器并启动
  - docker ps 
    - 查看容器
  - docker start stop
    - 启动和停止容器
  - docker exec -it <name> bash
    - 进入到容器环境
- 删除
  - 删除镜像
    - docker rmi
  - 删除容器
    - docker rm

