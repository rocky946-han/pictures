#!/bin/sh

## java env
#export JAVA_HOME=/usr/local/java/jdk1.8.0_181
#export JRE_HOME=$JAVA_HOME/jre

## you just need to change this param name
APP_NAME=web-prm-partner
currentdate=$(date +%Y%m%d)
SERVICE_DIR=/app/service/prm/web-prm-partner
SERVICE_NAME=web-prm-partner
JAR_NAME=$SERVICE_NAME\.jar
PID=$SERVICE_NAME\.pid
JAR_BACK_NAME=web-prm-partner_$currentdate\.jar

cd $SERVICE_DIR

case "$1" in

    start)
        #nohup $JRE_HOME/bin/java -Xms1024m -Xmx1024m -jar $JAR_NAME >/dev/null 2>&1 &
        nohup java -Xms4096m -Xmx4096m -jar $JAR_NAME >/dev/null 2>&1 &
		echo $! > $SERVICE_DIR/$PID
        echo "=== start $SERVICE_NAME"
        ;;

    stop)
        kill `cat $SERVICE_DIR/$PID`
        rm -rf $SERVICE_DIR/$PID
        echo "=== stop $SERVICE_NAME"

        sleep 5
        P_ID=`ps -ef | grep -w "$SERVICE_NAME" | grep -v "grep" | awk '{print $2}'`
	echo "=== $P_ID"
        if [ "$P_ID" == "" ]; then
            echo "=== $SERVICE_NAME process not exists or stop success"
        else
            echo "=== $SERVICE_NAME process pid is:$P_ID"
            echo "=== begin kill $SERVICE_NAME process, pid is:$P_ID"
            kill -9 $P_ID
        fi
        ;;

    restart)
        $0 stop
        sleep 2
        $0 start
        echo "=== restart $SERVICE_NAME"
        ;;

    *)
        ## restart
        $0 stop
        sleep 2
        $0 start
        ;;
esac
exit 0

