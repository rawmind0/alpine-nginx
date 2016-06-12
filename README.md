alpine-nginx
=============

This image is the nginx base. It comes from [alpine-monit][alpine-monit].

## Build

```
docker build -t rawmind/alpine-nginx:<version> .
```

## Versions

- `1.9.15-1` [(Dockerfile)](https://github.com/rawmind0/alpine-nginx/blob/1.9.15-1/Dockerfile)
- `1.9.15-0` [(Dockerfile)](https://github.com/rawmind0/alpine-nginx/blob/1.9.15-0/Dockerfile)


## Configuration

This image runs [nginx][nginx] with monit. nginx is started with user and group "nginx".

Besides, you can customize the configuration in several ways:

### Default Configuration

nginx is installed with the default configuration listening at 8080 and 8443 ports


### Custom Configuration

Nginx is installed under /opt/nginx and make use of /opt/nginx/conf/nginx.conf and /opt/nginx/sites/*.conf.

You can edit this files in order customize configuration

You could also include `FROM rawmind/alpine-nginx` at the top of your `Dockerfile`, and add your site files to /opt/nginx/www and your nginx config to /opt/nginx/sites



[alpine-monit]: https://github.com/rawmind0/alpine-monit/
[nginx]: http://nginx.org/