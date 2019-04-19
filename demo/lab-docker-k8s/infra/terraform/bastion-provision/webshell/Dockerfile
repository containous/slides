FROM tsl0922/ttyd:1.4.2-alpine
RUN apk add --no-cache openssh
RUN adduser -h /home/devoxx -s /bin/bash -D devoxx
RUN mkdir -p /home/devoxx/.ssh
RUN chown -R devoxx:devoxx /home/devoxx
USER devoxx
WORKDIR /home/devoxx
VOLUME ["/home/devoxx"]
