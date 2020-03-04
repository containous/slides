FROM node:11 AS webbuilder
WORKDIR /app
COPY ./hugo /app
RUN yarn install

ENV HUGO_VERSION 0.55.4

RUN curl -sSL -o hugo.tgz \
    https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.tar.gz \
    && tar xzf ./hugo.tgz \
    && mv ./hugo /usr/local/bin/hugo \
    && hugo version \
    && rm -f ./hugo.tgz
RUN hugo

FROM nginx:alpine AS webserver
COPY --from=webbuilder /app/public /usr/share/nginx/html
