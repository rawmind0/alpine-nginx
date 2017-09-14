alpine-nginx
=============

This image is the nginx base. It comes from [alpine-monit][alpine-monit].

## Build

```
docker build -t rawmind/alpine-nginx:<version> .
```

## Versions

- `1.12.1-5` [(Dockerfile)](https://github.com/rawmind0/alpine-nginx/blob/1.12.1-5/Dockerfile)
- `1.11.9-1` [(Dockerfile)](https://github.com/rawmind0/alpine-nginx/blob/1.11.9-1/Dockerfile)
- `1.10.2-1` [(Dockerfile)](https://github.com/rawmind0/alpine-nginx/blob/1.10.2-1/Dockerfile)
- `1.10.1-9` [(Dockerfile)](https://github.com/rawmind0/alpine-nginx/blob/1.10.1-9/Dockerfile)
- `1.9.15-3` [(Dockerfile)](https://github.com/rawmind0/alpine-nginx/blob/1.9.15-3/Dockerfile)


## Usage

This image runs [nginx][nginx] with monit.

Besides, you can customize the configuration in several ways:

### Default Configuration

nginx is installed with the default configuration: 

- SERVICE_HOME
```
/opt/nginx
```

- SERVICE_LOG_DIR
```
${SERVICE_HOME}"/log"
```

- SERVICE_LOG_FILES
```
${SERVICE_LOG_DIR}"/error.log"
```

- NGINX_CONF

```
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
```

- NGINX_SERVER_CONF

```
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
```

- NGINX_SERVER_NAME
```
default
```


### Custom Configuration

Nginx is installed under /opt/nginx and use config files /opt/nginx/conf/nginx.conf and /opt/nginx/sites/*.conf.

You could overwrite nginx and/or server config and and server name setting these env variables, ${NGINX_CONF} ${NGINX_SERVER_CONF} ${NGINX_SERVER_NAME}.

Default log is configured to show /opt/nginx/log/error.log. You could override it, setting env variable ${SERVICE_LOG_FILES}. Multiple values allowed with "," separator.

You could also include `FROM rawmind/alpine-nginx` at the top of your `Dockerfile`, and add your site files to /opt/nginx/www.



[alpine-monit]: https://github.com/rawmind0/alpine-monit/
[nginx]: http://nginx.org/
