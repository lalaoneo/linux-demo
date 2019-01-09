#!/bin/sh

echo "入参为：$1";

# 查看nginx的运行状态,用于判断是否在运行
nginxStatus=`docker inspect nginx -f '{{.State.Status}}'`
echo "$nginxStatus";

if [ "$1" = "start" ]; then
    echo "开始启动nginx容器";
    if [ "$nginxStatus" = "running" ]; then
        echo "nginx容器已经启动";
    else
        runResult=`docker run -d -p 80:80 --name nginx -v /home/service/docker/nginx/html:/usr/share/nginx/html -v /home/service/docker/nginx/conf/nginx.conf:/etc/nginx/nginx.conf:ro -v /home/service/docker/nginx/conf/conf.d:/etc/nginx/conf.d nginx:latest`;
        echo "$runResult";

        runResultLength=`expr length $runResult`;
        echo "$runResultLength";

        if [ "$runResultLength" -eq 64 ]; then
            echo "nginx容器已经启动";
        else
            echo "启动nginx容器失败，请大神干预";
        fi
    fi
elif [ "$1" = "stop" ]; then
    echo "开始关闭nginx容器";
    if [ "$nginxStatus" = "running" ]; then
        echo "nginx容器运行中";
        docker stop nginx;
        echo "停止nginx容器";
        docker rm nginx;
        echo "删除nginx容器";
    else
        echo "nginx容器非运行中";
        docker rm nginx;
        echo "删除nginx容器";
    fi
else
    echo "参数有误";
fi
