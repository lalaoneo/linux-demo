# Linux操作指南

### linux操作
    查看服务器CPU数量  ls -l /proc/acpi/processor/ | grep -v total | wc -l
    
    创建文件    touch file_name
    
    设置文件可执行     chmod +x file_name

### 安装centos7
    下载地址:http://mirrors.aliyun.com/centos/7.5.1804/isos/x86_64

    高版本安装docker可能存在问题,如果不行请换7.5.1804这个版本
    
    centos7默认使用firewall，可以关闭掉，换成iptables
    参考文档:https://www.cnblogs.com/kreo/p/4368811.html

### 创建文件夹
    mkdir /home/service/docker/nginx
    mkdir /home/service/docker/nginx/conf
    
### 安装docker
    参考文档：http://www.cnblogs.com/yufeng218/p/8370670.html

### docker通用
    命令：docker exec -it 6fed606745f8 /bin/sh
    
    docker logs -f container_id
    
#### docker run命令
    -d: 后台运行容器，并返回容器ID

    -i: 以交互模式运行容器，通常与 -t 同时使用

    -t: 为容器重新分配一个伪输入终端，通常与 -i 同时使用
    
### 安装consul
    docker search consul
    
    docker pull consul
    
    踩坑：没有加-client=0.0.0.0，映射了端口但打不开UI，是因为consul容器中的8500端口默认只绑定在172.0.0.1上
    
    执行请移步shell脚本

### 安装maven
    参考文档：https://www.cnblogs.com/HendSame-JMZ/p/6122188.html
    
### 安装zookeeper
    docker search zookeeper
    
    docker pull jplock/zookeeper
    
    执行请移步shell脚本
    
### 安装redis
    docker search redis
    
    docker pull redis
    
    执行请移步shell脚本
    
### 安装mysql
    docker search mysql
    
    docker pull mysql
    
    参考文档:https://www.cnblogs.com/li5206610/p/9284647.html
    
    执行请移步shell脚本
    
### 安装nginx
    docker search nginx
    
    docker pull nginx
    
    拷贝容器中的数据,挂载出来
    
    docker cp abc148296167:/usr/share/nginx/html /home/service/docker/nginx/html/
    
    docker cp abc148296167:/etc/nginx/nginx.conf /home/service/docker/nginx/conf/
    
    docker cp abc148296167:/etc/nginx/conf.d /home/service/docker/nginx/conf/
    
    执行请移步shell脚本
    
### 安装tomcat
    docker search tomcat
    
    docker pull tomcat
    
    把war上传到对应文件中,把Tomcat的webapps挂载出来,需要挂载的时候再设置
    -v /home/service/disconf/war/disconf-web.war:/usr/local/tomcat/webapps/disconf-web.war
    
    参考文档:https://blog.csdn.net/qq_32351227/article/details/78673591
    
    执行请移步shell脚本
    
### 安装kafka
    docker search kafka
    
    docker pull wurstmeister/kafka
    
    采坑：链接zookeeper的IP需要根据本地机器进行设置,否则会链接不上
    
    kafka连不上zookeeper解决办法：
    pkill docker 
    iptables -t nat -F 
    ifconfig docker0 down 
    brctl delbr docker0 
    systemctl restart docker
    
    执行请移步shell脚本

### shell脚本通用
    mkdir /home/service/docker/${具体项目名称}/bin
        
    把github-->linux-demo的脚本上传到对应目录中
    
    启动：./${具体项目名称}.sh start
    
    停止：./${具体项目名称}.sh stop
