alpine-nginx
=============

This image is the nginx base. It comes from rawmind/alpine-monit.

## Build

```
docker build -t rawmind/alpine-nginx:<version> .
```

## Versions

- `1.9.15` [(Dockerfile)](https://github.com/rawmind0/alpine-nginx/blob/master/Dockerfile)


## Usage

To use this image include `FROM rawmind/alpine-nginx` at the top of your `Dockerfile`, and add your site files to /opt/nginx/www and your nginx config to /opt/nginx/sites

The nginx service is started with monit and check for the 80 port is listening.