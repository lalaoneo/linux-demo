#!/bin/sh

echo "入参为：$1";

# 查看mysql的运行状态,用于判断是否在运行
mysqlStatus=`docker inspect mysql -f '{{.State.Status}}'`
echo "$mysqlStatus";

if [ "$1" = "start" ]; then
    echo "开始启动mysql容器";
    if [ "$mysqlStatus" = "running" ]; then
        echo "mysql容器已经启动";
    else
        runResult=`docker run -p 3306:3306 --name mysql -v /home/service/docker/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=lalaoneo  -d mysql:latest`;
        echo "$runResult";

        runResultLength=`expr length $runResult`;
        echo "$runResultLength";

        if [ "$runResultLength" -eq 64 ]; then
            echo "mysql容器已经启动";
        else
            echo "启动mysql容器失败，请大神干预";
        fi
    fi
elif [ "$1" = "stop" ]; then
    echo "开始关闭mysql容器";
    if [ "$mysqlStatus" = "running" ]; then
        echo "mysql容器运行中";
        docker stop mysql;
        echo "停止mysql容器";
        docker rm mysql;
        echo "删除mysql容器";
    else
        echo "mysql容器非运行中";
        docker rm mysql;
        echo "删除mysql容器";
    fi
else
    echo "参数有误";
fi
