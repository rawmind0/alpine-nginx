FROM rawmind/alpine-monit:0.3.3-2
MAINTAINER Raul Sanchez <rawmind@gmail.com>

# Install and configure nginx
RUN apk add --update nginx && rm -rf /var/cache/apk/* \
  && mkdir -p /tmp/nginx/client-body /opt/www

# Add config files
ADD root /
RUN chmod +x /usr/bin/*.sh

