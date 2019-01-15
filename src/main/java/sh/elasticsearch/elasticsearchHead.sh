#!/bin/sh

echo "入参为：$1";

# 查看elasticsearchHead的运行状态,用于判断是否在运行
elasticsearchHeadStatus=`docker inspect elasticsearchHead -f '{{.State.Status}}'`
echo "$elasticsearchHeadStatus";

if [ "$1" = "start" ]; then
    echo "开始启动elasticsearchHead容器";
    if [ "$elasticsearchHeadStatus" = "running" ]; then
        echo "elasticsearchHead容器已经启动";
    else
        runResult=`docker run -d --name elasticsearchHead -p 9100:9100 mobz/elasticsearch-head:5`;
        echo "$runResult";

        runResultLength=`expr length $runResult`;
        echo "$runResultLength";

        if [ "$runResultLength" -eq 64 ]; then
            echo "elasticsearchHead容器已经启动";
        else
            echo "启动elasticsearchHead容器失败，请大神干预";
        fi
    fi
elif [ "$1" = "stop" ]; then
    echo "开始关闭elasticsearchHead容器";
    if [ "$elasticsearchHeadStatus" = "running" ]; then
        echo "elasticsearchHead容器运行中";
        docker stop elasticsearchHead;
        echo "停止elasticsearchHead容器";
        docker rm elasticsearchHead;
        echo "删除elasticsearchHead容器";
    else
        echo "elasticsearchHead容器非运行中";
        docker rm elasticsearchHead;
        echo "删除elasticsearchHead容器";
    fi
else
    echo "参数有误";
fi
