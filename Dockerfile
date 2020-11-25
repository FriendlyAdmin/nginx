#
# This Dockerfile builts a production-ready web-server nginx image.
#
# To sucessfully build an image from this Dockerfile the following build ARGs must be provided:
# NGINX_VERSION
#

# nginx version to use.
ARG NGINX_VERSION

FROM nginx:$NGINX_VERSION-alpine

# We won't run Nginx as root, of course.
ENV USER=nginx
ENV GROUP=nginx

# dockerize script version to use
# This script will allow to wait for some other service to start before starting nginx,
# useful for Docker Compose deployment.
ENV DOCKERIZE_VERSION v0.6.1

#
# Preparation stage
#
    # Update apk to get the leatest versions of packages.
RUN apk update && \
    # Add openssl which is needed to run dockerize script.
    apk --no-cache add openssl && \
    # Download and unpack dockerize script.
    wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz && \
    # Add tini to use as an entrypoint
    apk --no-cache add tini && \
    # Remove apk cache to save some space.
    rm -rf /var/cache/apk/* && \
    # Remove default nginx server configs direcroty - we won't use it
    rm -rf /etc/nginx/conf.d && \
    # chown the configs direcroty to the user that will run nginx
    chown -R $USER:$GROUP /etc/nginx

# Add constant part of configs.
COPY --chown=$USER:$GROUP conf /etc/nginx/

# Declare anonymous volumes for this directories to persist data and run containers in read-only mode.
VOLUME /var/cache/nginx /run /tmp

# Run nginx as an arbitrary user.
USER $USER:$GROUP

# Override entrypoint - the source image includes a small entrypoint script, which functionality we don't need.
ENTRYPOINT [ "/sbin/tini", "--" ]

# Same as the source image. Dockerize script can be set up in docker-compose files.
CMD [ "nginx", "-g", "daemon off;" ]
