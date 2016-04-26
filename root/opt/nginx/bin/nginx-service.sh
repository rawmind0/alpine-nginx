#!/usr/bin/env bash

SERVICE_NAME=nginx

function log {
        echo `date` $ME - $@
}

function serviceStart {
    log "[ Starting ${SERVICE_NAME}... ]"
    /opt/nginx/bin/nginx
}

function serviceStop {
    log "[ Stoping ${SERVICE_NAME}... ]"
    pid=$(cat /opt/nginx/run/nginx.pid)
    kill -SIGTERM $pid
}

function serviceRestart {
    log "[ Restarting ${SERVICE_NAME}... ]"
    serviceStop
    serviceStart
}

case "$1" in
        "start")
            serviceStart
        ;;
        "stop")
            serviceStop
        ;;
        "restart")
            serviceRestart
        ;;
        *) echo "Usage: $0 restart|start|stop"
        ;;

esac
