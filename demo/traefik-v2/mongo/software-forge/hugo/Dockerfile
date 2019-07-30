FROM node:11 AS webbuilder
WORKDIR /app
COPY ./hugo /app
RUN npm install
RUN curl -sSL -o hugo.tgz \
    https://github.com/gohugoio/hugo/releases/download/v0.55.4/hugo_0.55.4_Linux-64bit.tar.gz \
    && tar xzf ./hugo.tgz \
    && mv ./hugo /usr/local/bin/hugo \
    && hugo version \
    && rm -f ./hugo.tgz
RUN hugo

FROM nginx:alpine AS webserver
COPY --from=webbuilder /app/public /usr/share/nginx/html
