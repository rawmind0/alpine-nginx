#!/usr/bin/env bash

SERVICE_LOG_DIR=${SERVICE_LOG_DIR:-${SERVICE_HOME}"/log"}
SERVICE_LOG_FILES=${SERVICE_LOG_FILES:-${SERVICE_LOG_DIR}"/error.log"}

function log {
        echo `date` $ME - $@
}

function serviceLog {
    log "[ Redirecting ${SERVICE_NAME} logs to stdout... ]"
    for LOG_FILE in $(echo ${SERVICE_LOG_FILES} | tr "," "\n") 
    do
        if [ ! -L ${LOG_FILE} ]; then
            if [ -e ${LOG_FILE} ]; then
                rm ${LOG_FILE}
            fi
            ln -sf /proc/1/fd/1 ${LOG_FILE}
        fi
    done
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
