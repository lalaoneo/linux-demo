#!/bin/sh

echo "入参为：$1";

# 查看filebeat的运行状态,用于判断是否在运行
filebeatStatus=`docker inspect filebeat -f '{{.State.Status}}'`
echo "$filebeatStatus";

if [ "$1" = "start" ]; then
    echo "开始启动filebeat容器";
    if [ "$filebeatStatus" = "running" ]; then
        echo "filebeat容器已经启动";
    else
        runResult=`docker run -dt --name filebeat -v /home/service/docker/filebeat/conf/filebeat.yml:/filebeat.yml --net=host prima/filebeat:latest`;
        echo "$runResult";

        runResultLength=`expr length $runResult`;
        echo "$runResultLength";

        if [ "$runResultLength" -eq 64 ]; then
            echo "filebeat容器已经启动";
        else
            echo "启动filebeat容器失败，请大神干预";
        fi
    fi
elif [ "$1" = "stop" ]; then
    echo "开始关闭filebeat容器";
    if [ "$filebeatStatus" = "running" ]; then
        echo "filebeat容器运行中";
        docker stop filebeat;
        echo "停止filebeat容器";
        docker rm filebeat;
        echo "删除filebeat容器";
    else
        echo "filebeat容器非运行中";
        docker rm filebeat;
        echo "删除filebeat容器";
    fi
else
    echo "参数有误";
fi
