#!/bin/sh

echo "入参为：$1";

# 查看elasticsearch的运行状态,用于判断是否在运行
elasticsearchStatus=`docker inspect elasticsearch -f '{{.State.Status}}'`
echo "$elasticsearchStatus";

if [ "$1" = "start" ]; then
    echo "开始启动elasticsearch容器";
    if [ "$elasticsearchStatus" = "running" ]; then
        echo "elasticsearch容器已经启动";
    else
        runResult=`docker run -d --name elasticsearch -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" -v /home/service/docker/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml -v /home/service/docker/elasticsearch/config/jvm.options:/usr/share/elasticsearch/config/jvm.options  -v /home/service/docker/elasticsearch/data:/usr/share/elasticsearch/data elasticsearch:6.5.4`;
        echo "$runResult";

        runResultLength=`expr length $runResult`;
        echo "$runResultLength";

        if [ "$runResultLength" -eq 64 ]; then
            echo "elasticsearch容器已经启动";
        else
            echo "启动elasticsearch容器失败，请大神干预";
        fi
    fi
elif [ "$1" = "stop" ]; then
    echo "开始关闭elasticsearch容器";
    if [ "$elasticsearchStatus" = "running" ]; then
        echo "elasticsearch容器运行中";
        docker stop elasticsearch;
        echo "停止elasticsearch容器";
        docker rm elasticsearch;
        echo "删除elasticsearch容器";
    else
        echo "elasticsearch容器非运行中";
        docker rm elasticsearch;
        echo "删除elasticsearch容器";
    fi
else
    echo "参数有误";
fi
