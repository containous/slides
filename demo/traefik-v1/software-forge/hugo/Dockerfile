FROM alpine:latest

RUN apk add --no-cache \
    curl tar gzip \
    git \
    openssh-client \
    rsync

# Download and install hugo
ENV HUGO_VERSION 0.55.4
ENV HUGO_BINARY hugo_${HUGO_VERSION}_linux-64bit.tar.gz

RUN mkdir -p /usr/local/src \
    && cd /usr/local/src \
    && curl -L https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} | tar -xz \
    && mv hugo /usr/local/bin/hugo \
    && curl -L https://bin.equinox.io/c/dhgbqpS8Bvy/minify-stable-linux-amd64.tgz | tar -xz \
    && mv minify /usr/local/bin/ \
    && addgroup -Sg 1000 hugo \
    && adduser -SG hugo -u 1000 -h /src hugo

ADD . /src
WORKDIR /src

# Expose default hugo port
EXPOSE 80

# By default, serve site
ENV HUGO_BASE_URL http://localhost:80
ENV HUGO_ENV docker
CMD hugo server -b ${HUGO_BASE_URL} --bind=0.0.0.0 --port 80
