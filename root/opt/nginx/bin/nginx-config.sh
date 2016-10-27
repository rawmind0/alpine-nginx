#!/usr/bin/env bash

SERVICE_USER=${SERVICE_USER:-"root"}
NGINX_MAIL_ENABLE=${NGINX_MAIL_ENABLE:-"false"}
NGINX_MAIL_PROTOCOLS=${NGINX_MAIL_PROTOCOLS:-"smtp-587 imap-143 pop3-110"}
NGINX_MAIL_AUTH_HTTP=${NGINX_MAIL_AUTH_HTTP:-"localhost"}
NGINX_MAIL_SSL_ENABLE=${NGINX_MAIL_SSL_ENABLE:-"false"}
NGINX_SSL_PATH=${NGINX_SSL_PATH:-"${SERVICE_HOME}/certs"}


cat << EOF > ${SERVICE_HOME}/conf/nginx.conf
user  ${SERVICE_USER};
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

    #gzip  on;

    include ${SERVICE_HOME}/sites/*.conf;
}
EOF

if [ "X${NGINX_MAIL_ENABLE}" == "Xtrue" ]; then
  cat << EOF >> ${SERVICE_HOME}/conf/nginx.conf

mail {
    include ${SERVICE_HOME}/mailhosts/*.conf;
}
EOF
  MAILPORTSCFG=(${NGINX_MAIL_PROTOCOLS// / })

  if [ "X${NGINX_MAIL_SSL_ENABLE}" == "Xtrue" ]; then
    filelist=`ls -1 ${NGINX_SSL_PATH}/*.key | cut -d"." -f1`
    RC=`echo $?`

    if [ $RC -eq 0 ]; then
      cat << EOF >> ${SERVICE_HOME}/mailhosts/ssl.conf
  ssl_certificate ${filelist[0]}.crt;
  ssl_certificate_key ${filelist[0]}.key;
  ssl_session_timeout 5m;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH;
  ssl_prefer_server_ciphers   on;
EOF
    fi
  fi

  echo "Generating mailhost configuration templates..."

  for portcfg in ${MAILPORTSCFG[*]}; 
  do
    aport=(${portcfg//-/ })
    protocol=${aport[0]}
    port=${aport[1]}
    secmode=${aport[2]}
   
    sslconf=""
    if [ -f "${SERVICE_HOME}/mailhosts/ssl.conf" ]; then
      if [ "${secmode}" == "starttls" ]; then
        sslconf="starttls only;"
      elif [ "${secmode}" == "ssl" ]; then
        sslconf="ssl on;"
      fi
    fi

    portpadded=$(printf "%04d" $port)
    porthigh="2${portpadded}"
    cat << EOF > ${SERVICE_HOME}/mailhosts/${portcfg}.conf
server {
    listen ${porthigh};
    server_name localhost;
    protocol ${protocol};
    auth_http ${NGINX_MAIL_AUTH_HTTP};
    ${sslconf}
}
EOF
  done
fi

if [ ! -f ${SERVICE_HOME}/sites/*.conf ]; then

    cat << EOF > ${SERVICE_HOME}/sites/example.conf
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
fi
