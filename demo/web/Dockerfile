# FROM nginx:stable-alpine AS webserver
# COPY ./quickstart/public /usr/share/nginx/html

FROM debian:jessie

# # Install pygments (for syntax highlighting) 
RUN apt-get -qq update \
	&& DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends curl git ca-certificates \
	&& rm -rf /var/lib/apt/lists/*

# Download and install hugo
ENV HUGO_VERSION 0.22.1
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.deb


RUN curl -sSL "https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY}" -o /tmp/hugo.deb
RUN dpkg -i /tmp/hugo.deb \
	&& rm /tmp/hugo.deb

WORKDIR /usr/share/blog

# Expose default hugo port
EXPOSE 80

# Automatically build site
ADD site/ /usr/share/blog
RUN hugo -d /usr/share/nginx/html/

# By default, serve site
ENV HUGO_BASE_URL http://localhost:80
CMD hugo server -b ${HUGO_BASE_URL} --bind=0.0.0.0 --port 80
