#!/usr/bin/env bash

DEFAULT_CONF=$(cat << EOF 
worker_processes  2;

error_log  ${SERVICE_HOME}/log/error.log warn;
pid        ${SERVICE_HOME}/run/nginx.pid;


events {
    worker_connections  1024;
}

http {
    include       ${SERVICE_HOME}/conf/mime.types;
    default_type  application/octet-stream;

    log_format  main  '\$remote_addr - \$remote_user [\$time_local] "\$request" '
                      '\$status \$body_bytes_sent "\$http_referer" '
                      '"\$http_user_agent" "\$http_x_forwarded_for"';

    access_log  ${SERVICE_HOME}/log/access.log  main;

    sendfile        off;
    #tcp_nopush     on;

    keepalive_timeout  65;
    gzip  on;

    include ${SERVICE_HOME}/sites/*.conf;
}
EOF
)

NGINX_CONF=${NGINX_CONF:-${DEFAULT_CONF}}
NGINX_FILE=${SERVICE_HOME}"/conf/nginx.conf"

if [ ! -f ${NGINX_FILE} ]; then
    cat << EOF > ${NGINX_FILE}
${NGINX_CONF}
EOF
fi

DEFAULT_SERVER=$(cat << EOF
server {
    listen 8080 default_server;

    root ${SERVICE_HOME}/www;
    index index.html index.htm;

    # Make site accessible from http://localhost/
    server_name localhost;

    location / {

        try_files \$uri \$uri/ /index.html;

    }
}
EOF
)

NGINX_SERVER_NAME=${NGINX_SERVER_NAME:-"default"}
NGINX_SERVER_CONF=${NGINX_SERVER_CONF:-${DEFAULT_SERVER}}
NGINX_SERVER_FILE=${SERVICE_HOME}"/sites/"${NGINX_SERVER_NAME}".conf"

if [ ! -f ${NGINX_SERVER_FILE} ]; then
    cat << EOF > ${NGINX_SERVER_FILE}
${NGINX_SERVER_CONF}
EOF
fi

NGINX_KEY=${NGINX_KEY:-""}
NGINX_KEY_FILE=${NGINX_KEY_FILE:-${SERVICE_HOME}"/certs/"${NGINX_SERVER_NAME}".key"}
NGINX_CERT=${NGINX_CERT:-""}
NGINX_CERT_FILE=${NGINX_CERT_FILE:-${SERVICE_HOME}"/certs/"${NGINX_SERVER_NAME}".crt"}

if [ -n "${NGINX_KEY}" ] && [ -n "${NGINX_CERT}" ]; then
    if [ ! -f ${NGINX_KEY_FILE} ]; then
        cat << EOF > ${NGINX_KEY_FILE}
${NGINX_KEY}
EOF
    fi

    if [ ! -f ${NGINX_CERT_FILE} ]; then
        cat << EOF > ${NGINX_CERT_FILE}
${NGINX_CERT}
EOF
fi
