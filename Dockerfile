FROM node:11-alpine

RUN npm config set unsafe-perm true

LABEL Maintainers="Damien DUPORTAL<damien@containo.us>"

 RUN npm config set unsafe-perm true

# Install Global dependencies and gulp 4.x globally
RUN apk add --no-cache \
      curl \
      git \
      tini \
  && npm install -g gulp npm-check-updates

# Install App's dependencies (dev and runtime)
COPY ./package.json /app/package.json
WORKDIR /app
RUN npm install

COPY ./gulp/tasks /app/tasks
COPY ./gulp/gulpfile.js /app/gulpfile.js

VOLUME ["/app"]

# HTTP
EXPOSE 8000

ENTRYPOINT ["/sbin/tini","-g","gulp"]
CMD ["default"]
