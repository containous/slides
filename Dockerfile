FROM node:10-alpine

LABEL Maintainers="Damien DUPORTAL<damien.duportal@gmail.com>"

# Install Global dependencies and gulp 4.x globally
RUN apk add --no-cache \
      curl \
      git \
      tini \
  && npm install -g gulp@latest

# Install App's dependencies (dev and runtime)
COPY ./package.json /app/package.json
COPY ./npm-shrinkwrap.json /app/npm-shrinkwrap.json
WORKDIR /app
RUN npm install

COPY ./gulp/tasks /app/tasks
COPY ./gulp/gulpfile.js /app/gulpfile.js

VOLUME ["/app"]

# HTTP
EXPOSE 8000

ENTRYPOINT ["/sbin/tini","-g","gulp"]
CMD ["default"]
