#!/usr/bin/env bash

SERVICE_LOG_DIR=${KAFKA_LOG_DIRS:-${SERVICE_HOME}"/log"}
SERVICE_LOG_FILE=${SERVICE_LOG_FILE:-${SERVICE_LOG_DIR}"/error.log"}

function log {
        echo `date` $ME - $@
}

function serviceLog {
    log "[ Redirecting ${SERVICE_NAME} log to stdout... ]"
    if [ ! -L ${SERVICE_LOG_FILE} ]; then
        rm ${SERVICE_LOG_FILE}
        ln -sf /proc/1/fd/1 ${SERVICE_LOG_FILE}
    fi
}

function serviceConf {
    log "[ Configuring ${SERVICE_NAME}... ]"
    if [ ! -e ${SERVICE_HOME}/conf/nginx.conf ]; then
        ${SERVICE_HOME}/bin/nginx-config.sh
    fi
}

function serviceStart {
    log "[ Starting ${SERVICE_NAME}... ]"
    serviceLog
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
    /opt/monit/bin/monit reload
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
