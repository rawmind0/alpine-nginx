FROM rawmind/alpine-monit:0.3.3-2
MAINTAINER Raul Sanchez <rawmind@gmail.com>

#Set environment
ENV NGINX_VERSION=1.9.15 \
    NGINX_HOME=/opt/nginx \
    NGINX_URL=http://nginx.org/download 
ENV PATH=${PATH}:${NGINX_HOME}/bin 

# Compile and install nginx
RUN apk add --update gcc musl-dev make openssl-dev pcre pcre-dev zlib-dev\
  && mkdir -p /opt/src; cd /opt/src \
  && curl -sS ${NGINX_URL}/nginx-${NGINX_VERSION}.tar.gz | gunzip -c - | tar -xf - \
  && cd /opt/src/nginx-${NGINX_VERSION} \
  && ./configure \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --prefix=${NGINX_HOME} \
        --modules-path=${NGINX_HOME}/modules \
        --http-log-path=${NGINX_HOME}/log/access.log \
        --error-log-path=${NGINX_HOME}/log/error.log \
        --sbin-path=${NGINX_HOME}/bin/nginx \
        --pid-path=${NGINX_HOME}/run/nginx.pid   \
        --lock-path=${NGINX_HOME}/run/nginx.lock  \
  && make -j2 \
  && make install \
  && apk del gcc musl-dev make openssl-dev pcre-dev zlib-dev \
  && rm -rf /opt/src /var/cache/apk/*

# Add config files
ADD root /
RUN chmod +x ${NGINX_HOME}/bin/*.sh

WORKDIR $NGINX_HOME

EXPOSE 80 443
