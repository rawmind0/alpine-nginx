FROM rawmind/alpine-monit:0.5.18-1
MAINTAINER Raul Sanchez <rawmind@gmail.com>

#Set environment
ENV SERVICE_VERSION=1.10.1 \
    SERVICE_NAME=nginx \
    SERVICE_HOME=/opt/nginx \
    SERVICE_URL=http://nginx.org/download \
    SERVICE_USER=nginx \
    SERVICE_UID=10004 \
    SERVICE_GROUP=nginx \
    SERVICE_GID=10004 
ENV PATH=${PATH}:${SERVICE_HOME}/bin 

# Compile and install nginx
RUN apk add --update gcc musl-dev make openssl-dev pcre pcre-dev zlib-dev\
  && mkdir -p /opt/src; cd /opt/src \
  && curl -sS ${SERVICE_URL}/nginx-${SERVICE_VERSION}.tar.gz | gunzip -c - | tar -xf - \
  && cd /opt/src/nginx-${SERVICE_VERSION} \
  && ./configure \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --prefix=${SERVICE_HOME} \
        --modules-path=${SERVICE_HOME}/modules \
        --http-log-path=${SERVICE_HOME}/log/access.log \
        --error-log-path=${SERVICE_HOME}/log/error.log \
        --sbin-path=${SERVICE_HOME}/bin/nginx \
        --pid-path=${SERVICE_HOME}/run/nginx.pid   \
        --lock-path=${SERVICE_HOME}/run/nginx.lock  \
  && make -j2 \
  && make install \
  && apk del gcc musl-dev make openssl-dev pcre-dev zlib-dev \
  && rm -rf /opt/src /var/cache/apk/* \
  && addgroup -g ${SERVICE_GID} ${SERVICE_GROUP} \
  && adduser -g "${SERVICE_NAME} user" -D -h ${SERVICE_HOME} -G ${SERVICE_GROUP} -s /sbin/nologin -u ${SERVICE_UID} ${SERVICE_USER} 

# Add config files
ADD root /
RUN chmod +x ${SERVICE_HOME}/bin/*.sh \
  && chown -R ${SERVICE_USER}:${SERVICE_GROUP} ${SERVICE_HOME} /opt/monit

USER $SERVICE_USER
WORKDIR $NGINX_HOME

EXPOSE 8080 8443
