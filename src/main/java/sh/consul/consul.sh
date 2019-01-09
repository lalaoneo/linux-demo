#!/bin/sh

echo "入参为：$1";

# 查看consul的运行状态,用于判断是否在运行
consulStatus=`docker inspect consul -f '{{.State.Status}}'`
echo "$consulStatus";

if [ "$1" = "start" ]; then
    echo "开始启动consul容器";
    if [ "$consulStatus" = "running" ]; then
        echo "consul容器已经启动";
    else
        runResult=`docker run -d -p 8500:8500 --name consul consul:latest consul agent -dev -client=0.0.0.0`;
        echo "$runResult";

        runResultLength=`expr length $runResult`;
        echo "$runResultLength";

        if [ "$runResultLength" -eq 64 ]; then
            echo "consul容器已经启动";
        else
            echo "启动consul容器失败，请大神干预";
        fi
    fi
elif [ "$1" = "stop" ]; then
    echo "开始关闭consul容器";
    if [ "$consulStatus" = "running" ]; then
        echo "consul容器运行中";
        docker stop consul;
        echo "停止consul容器";
        docker rm consul;
        echo "删除consul容器";
    else
        echo "consul容器非运行中";
        docker rm consul;
        echo "删除consul容器";
    fi
else
    echo "参数有误";
fi
