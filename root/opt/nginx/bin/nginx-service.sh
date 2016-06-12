#!/usr/bin/env bash

function log {
        echo `date` $ME - $@
}

function serviceLog {
    log "[ Redirecting ${SERVICE_NAME} log... ]"
    if [ -e ${SERVICE_HOME}/log/error.log ]; then
        rm ${SERVICE_HOME}/log/error.log
    fi
    ln -sf /proc/1/fd/1 ${SERVICE_HOME}/log/error.log
}

function serviceConf {
    log "[ Configuring ${SERVICE_NAME}... ]"
    if [ ! -e ${SERVICE_HOME}/conf/nginx.conf ]; then
        ${SERVICE_HOME}/bin/nginx-config.sh
    fi
}

function serviceStart {
    log "[ Starting ${SERVICE_NAME}... ]"
    serviceConf
    ${SERVICE_HOME}/bin/nginx
}

function serviceStop {
    log "[ Stoping ${SERVICE_NAME}... ]"
    pid=$(cat ${SERVICE_HOME}/run/nginx.pid)
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
