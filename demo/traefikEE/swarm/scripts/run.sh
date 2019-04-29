#!/bin/bash

IMAGES_CACHE_DIR=${IMAGES_CACHE_DIR:-false}

set -eu -o pipefail

command -v sind >/dev/null || (
    echo "Error: sind is required: https://github.com/jlevesy/sind#installation."
    exit 1
)

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd -P)"
DEMO_DIR="${CURRENT_DIR}/.."
SIND_CLUSTERNAME=dockerswarm
export DOCKER_HOST=""

pushd "${DEMO_DIR}"

# Prepare Docker Images
docker build -t containous/webapp ./webapp/
docker pull containous/whoami

# Create swarm cluster
sind create --cluster="${SIND_CLUSTERNAME}" \
    --timeout=240s \
    --managers=3 \
    --workers=2 \
    --ports 55055:55055 \
    --ports 80:80 \
    --ports 8080:8080 \
    --ports 443:443 \
    --ports 8443:8443 \
    --ports 6443:6443

# Connect your docker cli to the docker swarm daemon:
eval "$(sind env --cluster="${SIND_CLUSTERNAME}")"

# Load cached images
sind push --timeout=240s --cluster="${SIND_CLUSTERNAME}" containous/whoami
sind push --timeout=240s --cluster="${SIND_CLUSTERNAME}" containous/webapp

echo "== Docker Swarm cluster ready"

exit 0
