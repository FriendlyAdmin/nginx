# FriendlyAdmin/nginx

A slightly customized Nginx Docker image with a reasonable configuration baked in.

Intended to serve a Tor hidden service.

Built for Docker Hub automatically by utilizing a GitHub hook, see `hooks/build` for details.

[Docker Hub repo](https://hub.docker.com/r/friendlyadmin/nginx)

## Usage

To run the image you must provide an actual `server.conf` Nginx configuration file containing `server { ... }` declarations. See `example_server.conf`. And you also must provide a public directory of your actual website or an application using a Docker volume.

The easiest way to run a hidden service using this image is by using Docker Compose utility and a `docker-compose.yaml` config from [this repo](https://github.com/FriendlyAdmin/tor-hs).

Or run it as a standalone container like so:

```
docker container run --read-only -d --name=nginx \
    -v server.conf:/etc/nginx/server.conf:ro \
    -v ./public:/var/www/public:ro \
    friendlyadmin/nginx:latest
```

## Building

This image is only a slightly customized official Nginx Docker image, to build the image manually run from inside the repo root directory:

```
docker build --build-arg NGINX_VERSION=1.19 -t YOUR_DESIRED_IMAGE_TAG .
```

You must provide `NGINX_VERSION` build argument, see tags on [Docker Hub Nginx repo](https://hub.docker.com/_/nginx) for what versions of Nginx image are available.

## See also

[FriendlyAdmin/tor](https://github.com/FriendlyAdmin/tor) - General purpose Tor Docker image used in building the Onionbalance image.

[FriendlyAdmin/onionbalance](https://github.com/FriendlyAdmin/onionbalance) - Tor and Onionbalance neatly packaged in a single Docker image to serve as a separated Onionbalance setup for a Tor hidden service.

[FriendlyAdmin/tor-hs](https://github.com/FriendlyAdmin/tor-hs) - A pre-made simple Docker Compose configuration for running an Onionbalanced Tor hidden service.
