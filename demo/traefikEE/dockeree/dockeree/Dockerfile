FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     software-properties-common

ENV DOCKER_EE_URL="https://storebits.docker.com/ee/m/sub-25b30dfc-8f64-4f7b-b8eb-91bd0e860d0a"

RUN curl -fsSL "${DOCKER_EE_URL}/ubuntu/gpg" | apt-key add - && \
    add-apt-repository \
    "deb [arch=amd64] $DOCKER_EE_URL/ubuntu \
    $(lsb_release -cs) \
    $DOCKER_EE_VERSION stable" && \
    apt-get update && \
    apt-get install -y docker-ee
  
# Install the magic wrapper. Thanks to https://gitlab.com/Plasticity/ubuntu-dind
ADD wrapdocker.sh /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

ADD ucp.toml /ucp.toml

# Define additional metadata for our image.
VOLUME /var/lib/docker
VOLUME /var/lib/kubelet
CMD ["wrapdocker"]

ENV PORT=2375
EXPOSE $PORT

ENTRYPOINT ["wrapdocker"]