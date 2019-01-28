#!/bin/sh

echo "入参为：$1";

# 查看kibana的运行状态,用于判断是否在运行
kibanaStatus=`docker inspect kibana -f '{{.State.Status}}'`
echo "$kibanaStatus";

if [ "$1" = "start" ]; then
    echo "开始启动kibana容器";
    if [ "$kibanaStatus" = "running" ]; then
        echo "kibana容器已经启动";
    else
        runResult=`docker run -dt --name kibana -e ELASTICSEARCH_URL=http://192.168.245.128:9200 -p 5601:5601 kibana:6.5.4`;
        echo "$runResult";

        runResultLength=`expr length $runResult`;
        echo "$runResultLength";

        if [ "$runResultLength" -eq 64 ]; then
            echo "kibana容器已经启动";
        else
            echo "启动kibana容器失败，请大神干预";
        fi
    fi
elif [ "$1" = "stop" ]; then
    echo "开始关闭kibana容器";
    if [ "$kibanaStatus" = "running" ]; then
        echo "kibana容器运行中";
        docker stop kibana;
        echo "停止kibana容器";
        docker rm kibana;
        echo "删除kibana容器";
    else
        echo "kibana容器非运行中";
        docker rm kibana;
        echo "删除kibana容器";
    fi
else
    echo "参数有误";
fi
