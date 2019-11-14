FROM alpine:edge

RUN apk add --no-cache hugo npm nodejs

ADD ./package.json* /src/
WORKDIR /src
RUN npm install

ADD . /src

# Expose default hugo port
EXPOSE 80

# By default, serve site
ENV HUGO_BASE_URL http://localhost:80
ENV HUGO_ENV docker
CMD hugo server --baseURL ${HUGO_BASE_URL} --bind=0.0.0.0 --port 80 --disableLiveReload=true
