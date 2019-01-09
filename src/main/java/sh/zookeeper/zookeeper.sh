#!/bin/sh

echo "入参为：$1";

# 查看zookeeper的运行状态,用于判断是否在运行
zookeeperStatus=`docker inspect zookeeper -f '{{.State.Status}}'`
echo "$zookeeperStatus";

if [ "$1" = "start" ]; then
    echo "开始启动zookeeper容器";
    if [ "$zookeeperStatus" = "running" ]; then
        echo "zookeeper容器已经启动";
    else
        runResult=`docker run -d --name zookeeper -h zookeeper -p 2181:2181 jplock/zookeeper:latest`;
        echo "$runResult";

        runResultLength=`expr length $runResult`;
        echo "$runResultLength";

        if [ "$runResultLength" -eq 64 ]; then
            echo "zookeeper容器已经启动";
        else
            echo "启动zookeeper容器失败，请大神干预";
        fi
    fi
elif [ "$1" = "stop" ]; then
    echo "开始关闭zookeeper容器";
    if [ "$zookeeperStatus" = "running" ]; then
        echo "zookeeper容器运行中";
        docker stop zookeeper;
        echo "停止zookeeper容器";
        docker rm zookeeper;
        echo "删除zookeeper容器";
    else
        echo "zookeeper容器非运行中";
        docker rm zookeeper;
        echo "删除zookeeper容器";
    fi
else
    echo "参数有误";
fi
