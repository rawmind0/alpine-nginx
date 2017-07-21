alpine-nginx
=============

This image is the nginx base. It comes from [alpine-monit][alpine-monit].

## Build

```
docker build -t rawmind/alpine-nginx:<version> .
```

## Versions

- `1.12.1-2` [(Dockerfile)](https://github.com/rawmind0/alpine-nginx/blob/1.12.1-2/Dockerfile)
- `1.11.9-1` [(Dockerfile)](https://github.com/rawmind0/alpine-nginx/blob/1.11.9-1/Dockerfile)
- `1.10.2-1` [(Dockerfile)](https://github.com/rawmind0/alpine-nginx/blob/1.10.2-1/Dockerfile)
- `1.10.1-9` [(Dockerfile)](https://github.com/rawmind0/alpine-nginx/blob/1.10.1-9/Dockerfile)
- `1.9.15-3` [(Dockerfile)](https://github.com/rawmind0/alpine-nginx/blob/1.9.15-3/Dockerfile)


## Configuration

This image runs [nginx][nginx] with monit.

Besides, you can customize the configuration in several ways:

### Default Configuration

nginx is installed with the default configuration listening at 8080 and 8443 ports 


### Custom Configuration

Nginx is installed under /opt/nginx and make use of /opt/nginx/conf/nginx.conf and /opt/nginx/sites/*.conf.

You could overwrite nginx config, server name and and server config with env variables, ${NGINX_CONF} ${NGINX_SERVER_CONF} ${NGINX_SERVER_NAME}.

You could also include `FROM rawmind/alpine-nginx` at the top of your `Dockerfile`, and add your site files to /opt/nginx/www and your nginx config to /opt/nginx/sites



[alpine-monit]: https://github.com/rawmind0/alpine-monit/
[nginx]: http://nginx.org/
