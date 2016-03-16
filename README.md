alpine-nginx
=============

alpine-nginx image based in alpine-monit

To build

```
docker build -t <repo>/alpine-nginx:<version> .
```

To run:

```
docker run -it <repo>/alpine-nginx:<version> 
```

## Versions

- `0.0.1` [(Dockerfile)](https://github.com/rawmind0/alpine-nginx/blob/master/Dockerfile)

## Usage

To use this image include `FROM <repo>/alpine-nginx` at the top of your `Dockerfile`, and add your site files to /opt/www and your nginx config to /etc/nginx/conf.d

The nginx service is started with monit and check for the 80 port is listening.
