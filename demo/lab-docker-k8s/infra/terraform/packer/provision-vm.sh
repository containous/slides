#!/bin/bash

set -eux -o pipefail

COMPOSE_VERSION=1.23.2
HELM_VERSION=2.13.1

# Install Docker from https://docs.docker.com/install/linux/docker-ce/debian/

apt-get remove -y docker docker-engine docker.io containerd runc || true
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
apt-key fingerprint 0EBFCD88 | grep 'CD88'
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get upgrade -y
apt-get install -y docker-ce docker-ce-cli containerd.io
docker info

# Install docker-compose
curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod a+x /usr/local/bin/docker-compose
docker-compose -v

usermod -aG docker devoxx

# Install Utilities
apt-get install -y --no-install-recommends \
    bash-completion \
    dnsutils \
    htop \
    nano \
    vim

## Prepare Kubernetes
# kubectl
curl -sSL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.13.5/bin/linux/amd64/kubectl
chmod a+x /usr/local/bin/kubectl
# Helm
curl -sSL -o /tmp/helm.tgz "https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
tar xzf /tmp/helm.tgz -C /tmp
cp /tmp/linux-amd64/helm /usr/local/bin/
rm -rf /tmp/helm.tgz /tmp/linux-amd64

# Enable completions
mkdir -p /etc/bash_completion.d
kubectl completion bash >/etc/bash_completion.d/kubectl
helm completion bash >/etc/bash_completion.d/helm
curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker

# Prepare images
DESTINATION_DIR=/kube/images
mkdir -p "${DESTINATION_DIR}"
for IMAGE in rancher/k3s:v0.3.0 rancher/local-path-provisioner:v0.0.5 coredns/coredns:1.3.0 \
    "gcr.io/kubernetes-helm/tiller:v${HELM_VERSION}"
do
    docker pull "${IMAGE}"
    TAR_FILENAME="$(echo "${IMAGE}" | sed 's#/#-#g' | sed 's#:#-#g').tar"

    docker save "${IMAGE}" -o "${DESTINATION_DIR}/${TAR_FILENAME}"
done

# Custom tunings
echo 'set paste' > /home/devoxx/.vimrc
