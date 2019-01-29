# Linux操作指南

### linux操作
    查看服务器CPU数量  ls -l /proc/acpi/processor/ | grep -v total | wc -l
    
    创建文件    touch file_name
    
    设置文件可执行     chmod +x file_name

### iptables

    service iptables restart

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

### 安装JDK8
    参考文档：https://www.cnblogs.com/ocean-sky/p/8392444.html

### 安装ElasticSearch
    
    docker search elasticsearch
    
    没有latest的TAG,需要指定版本号拉取,可以在docker hub上查询
    docker pull elasticsearch:6.5.4
    
    把elasticsearch.yml挂载出来: docker cp 33bbc8741bc1:/usr/share/elasticsearch/config/elasticsearch.yml /home/service/docker/elasticsearch/config/
    
    把jvm.options挂载出来：docker cp 33bbc8741bc1:/usr/share/elasticsearch/config/jvm.options /home/service/docker/elasticsearch/config/
    
    把data挂载出来：docker cp 33bbc8741bc1:/usr/share/elasticsearch/data /home/service/docker/elasticsearch/data
    
    修改jvm.options的内存,改小一点:-Xms256m -Xmx256m
    
    在elasticsearch.yml文件增加跨域配置: http.cors.enabled: true
                                       http.cors.allow-origin: "*"
    
    参考文档: https://www.cnblogs.com/jianxuanbing/p/9410800.html

### 安装elasticsearch-head
    
    docker search elasticsearch-head
    
    没有latest的TAG,需要指定版本号拉取,可以在docker hub上查询
    docker pull mobz/elasticsearch-head:5
    
    参考文档: https://www.cnblogs.com/jianxuanbing/p/9410800.html

### 安装elastic-job-lite-console
    
    参考文档：https://blog.csdn.net/lovelong8808/article/details/80393290
    
    需要打开端口：iptables -A INPUT -p tcp --dport 8899 -j ACCEPT
    
    service iptables save
    
    才可以访问虚拟机的系统
    
    需要在start.sh脚本最后一行末尾加一个 & ，让其后台运行
    
### 安装apollo
* apollo安装：[参考文档](https://github.com/nobodyiam/apollo-build-scripts)

* 在/etc/sysconfig/iptables增加端口8070:`-A INPUT -p tcp -m state --state NEW -m tcp --dport 8070 -j ACCEPT`

* 定制apollo命令：`./demo.sh stop`

### 安装kibana

* `docker search kibana`

* `docker pull kibana:6.5.4`

* 在iptables中增加端口5601,9200,重启iptables

* 注意修改kibana.sh的IP地址

### Logstash安装

* `docker search logstash`

* `docker pull logstash:6.5.4`

* docker run -it --rm logstash:6.5.4 -e 'input { stdin { } } output { stdout { } }'

* docker cp 8c7fc5a8729c:/usr/share/logstash/config/logstash-sample.conf /home/service/docker/logstash/conf

* 把文件名logstash-sample.conf更改为logstash.conf `mv logstash-sample.conf logstash.conf`

* 修改conf文件的localhost为192.168.174.128

* docker cp 8c7fc5a8729c:/usr/share/logstash/config/logstash.yml /home/service/docker/logstash/conf

* 修改yml文件的elasticsearch为192.168.174.128

* 导出logstash-sample.conf后增加stdin { }  stdout { } 进行测试,目前不通,发现logstash镜像的配置文件在pipeline里,挂载错了

* 每次重启需要删除filebeat-*的索引,具体是啥看kibana的索引列表: `curl -XDELETE http://localhost:9200/filebeat-2019.01.29`

* 修改logstash.conf的index,index => "filebeat-%{+YYYY.MM.dd}",因为调试已经产生了logstash-%{+YYYY.MM.dd},要么删除要么修改index

### filebeat安装

* `docker search filebeat`

* `docker pull docker.elastic.co/beats/filebeat:6.5.4`

* 在docker文件夹中创建filebeat/bin/filebeat.sh filebeat/conf/filebeat.yml

* filebeat.yml的配置信息[参考文档](https://github.com/elastic/beats/edit/master/filebeat/filebeat.yml)
    * 配置信息已经在项目的filebeat/filebeat.yml

* 复制filebeat.yml文件时,可能第一行的###################### Filebeat 会变成t，因为文件太长，注意修改一下

* 注意修改filebeat.yml对应logstash的IP地址

* 在iptables打开端口5044,重启iptables

* 需要开启apollo进行操作,测试时抓取apollo的日志
