#!/bin/sh

echo "入参为：$1";

# 查看logstash的运行状态,用于判断是否在运行
logstashStatus=`docker inspect logstash -f '{{.State.Status}}'`
echo "$logstashStatus";

if [ "$1" = "start" ]; then
    echo "开始启动logstash容器";
    if [ "$logstashStatus" = "running" ]; then
        echo "logstash容器已经启动";
    else
        runResult=`docker run -dt --name logstash -p 5044:5044 -v /home/service/docker/logstash/conf/logstash.conf:/usr/share/logstash/pipeline/logstash.conf -v /home/service/docker/logstash/conf/logstash.yml:/usr/share/logstash/config/logstash.yml logstash:6.5.4`;
        echo "$runResult";

        runResultLength=`expr length $runResult`;
        echo "$runResultLength";

        if [ "$runResultLength" -eq 64 ]; then
            echo "logstash容器已经启动";
        else
            echo "启动logstash容器失败，请大神干预";
        fi
    fi
elif [ "$1" = "stop" ]; then
    echo "开始关闭logstash容器";
    if [ "$logstashStatus" = "running" ]; then
        echo "logstash容器运行中";
        docker stop logstash;
        echo "停止logstash容器";
        docker rm logstash;
        echo "删除logstash容器";
    else
        echo "logstash容器非运行中";
        docker rm logstash;
        echo "删除logstash容器";
    fi
else
    echo "参数有误";
fi
