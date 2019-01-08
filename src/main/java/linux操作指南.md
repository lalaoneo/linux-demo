# Linux操作指南

### 安装centos7
    下载地址:http://mirrors.aliyun.com/centos/7.5.1804/isos/x86_64

    高版本安装docker可能存在问题,如果不行请换7.5.1804这个版本
    
    centos7默认使用firewall，可以关闭掉，换成iptables
    参考文档:https://www.cnblogs.com/kreo/p/4368811.html

### 创建文件夹
    mkdir /home/service/docker/nginx/html
    mkdir /home/service/docker/nginx/conf
    
### 安装docker
    参考文档：http://www.cnblogs.com/yufeng218/p/8370670.html

### 进入容器
    命令：docker exec -it 6fed606745f8 /bin/sh
    
#### docker run命令
    -d: 后台运行容器，并返回容器ID

    -i: 以交互模式运行容器，通常与 -t 同时使用

    -t: 为容器重新分配一个伪输入终端，通常与 -i 同时使用
    
### 安装consul
    docker search consul
    
    docker pull consul
    
    启动：docker run -d -p 8500:8500 --name consul consul:latest consul agent -dev -client=0.0.0.0
    
    踩坑：没有加-client=0.0.0.0，映射了端口但打不开UI，是因为consul容器中的8500端口默认只绑定在172.0.0.1上
    
### 安装maven
    参考文档：https://www.cnblogs.com/HendSame-JMZ/p/6122188.html