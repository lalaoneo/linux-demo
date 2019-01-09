#!/bin/sh

echo "入参为：$1";

# 查看redis的运行状态,用于判断是否在运行
redisStatus=`docker inspect redis -f '{{.State.Status}}'`
echo "$redisStatus";

if [ "$1" = "start" ]; then
    echo "开始启动redis容器";
    if [ "$redisStatus" = "running" ]; then
        echo "redis容器已经启动";
    else
        runResult=`docker run -d -p 6379:6379 --name redis redis:latest`;
        echo "$runResult";

        runResultLength=`expr length $runResult`;
        echo "$runResultLength";

        if [ "$runResultLength" -eq 64 ]; then
            echo "redis容器已经启动";
        else
            echo "启动redis容器失败，请大神干预";
        fi
    fi
elif [ "$1" = "stop" ]; then
    echo "开始关闭redis容器";
    if [ "$redisStatus" = "running" ]; then
        echo "redis容器运行中";
        docker stop redis;
        echo "停止redis容器";
        docker rm redis;
        echo "删除redis容器";
    else
        echo "redis容器非运行中";
        docker rm redis;
        echo "删除redis容器";
    fi
else
    echo "参数有误";
fi
