#!/bin/sh

echo "入参为：$1";

# 查看kafka的运行状态,用于判断是否在运行
kafkaStatus=`docker inspect kafka -f '{{.State.Status}}'`
echo "$kafkaStatus";

if [ "$1" = "start" ]; then
    echo "开始启动kafka容器";
    if [ "$kafkaStatus" = "running" ]; then
        echo "kafka容器已经启动";
    else
        echo "先查看zookeeper是否启动";

        zookeeperStatus=`docker inspect zookeeper -f '{{.State.Status}}'`
        echo "$zookeeperStatus";

        if [ "$zookeeperStatus" = "running" ]; then
            echo "zookeeper容器已经启动";

            runResult=`docker run -d -p 9092:9092 --name kafka -e KAFKA_ZOOKEEPER_CONNECT="192.168.245.128:2181" -e KAFKA_ADVERTISED_HOST_NAME="192.168.245.128" -e LANG="en_US.UTF-8" wurstmeister/kafka:latest`;
            echo "$runResult";

            runResultLength=`expr length $runResult`;
            echo "$runResultLength";

            if [ "$runResultLength" -eq 64 ]; then
                echo "kafka容器已经启动";
            else
                echo "启动kafka容器失败，请大神干预";
            fi
        else
            echo "zookeeper容器没有启动,请先启动zookeeper";
        fi
    fi
elif [ "$1" = "stop" ]; then
    echo "开始关闭kafka容器";
    if [ "$kafkaStatus" = "running" ]; then
        echo "kafka容器运行中";
        docker stop kafka;
        echo "停止kafka容器";
        docker rm kafka;
        echo "删除kafka容器";
    else
        echo "kafka容器非运行中";
        docker rm kafka;
        echo "删除kafka容器";
    fi
else
    echo "参数有误";
fi
