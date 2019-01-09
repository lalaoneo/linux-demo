#!/bin/sh

echo "入参为：$1";

# 查看tomcat的运行状态,用于判断是否在运行
tomcatStatus=`docker inspect tomcat -f '{{.State.Status}}'`
echo "$tomcatStatus";

if [ "$1" = "start" ]; then
    echo "开始启动tomcat容器";
    if [ "$tomcatStatus" = "running" ]; then
        echo "tomcat容器已经启动";
    else
        runResult=`docker run -d --name tomcat -p 8080:8080 tomcat:latest`;
        echo "$runResult";

        runResultLength=`expr length $runResult`;
        echo "$runResultLength";

        if [ "$runResultLength" -eq 64 ]; then
            echo "tomcat容器已经启动";
        else
            echo "启动tomcat容器失败，请大神干预";
        fi
    fi
elif [ "$1" = "stop" ]; then
    echo "开始关闭tomcat容器";
    if [ "$tomcatStatus" = "running" ]; then
        echo "tomcat容器运行中";
        docker stop tomcat;
        echo "停止tomcat容器";
        docker rm tomcat;
        echo "删除tomcat容器";
    else
        echo "tomcat容器非运行中";
        docker rm tomcat;
        echo "删除tomcat容器";
    fi
else
    echo "参数有误";
fi
