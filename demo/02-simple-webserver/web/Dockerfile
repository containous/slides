#### Create web site content from data
FROM alpine AS builder
LABEL Maintainer="Damien DUPORTAL<damien@containo.us>"
RUN apk add --no-cache hugo
WORKDIR /data
COPY ./data /data
RUN hugo 

#### Build web server with only the static content
FROM nginx:stable-alpine AS webserver
COPY --from=builder /data/public /usr/share/nginx/html
