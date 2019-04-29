#!/bin/bash

IMAGES_CACHE_DIR=${IMAGES_CACHE_DIR:-false}

set -eu -o pipefail

command -v sind >/dev/null || (
    echo "Error: sind is required: https://github.com/jlevesy/sind#installation."
    exit 1
)

export DOCKEREE_CONTAINOUS_LICENSE="$(cat "/keybase/team/containous/dockeree.lic")"

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd -P)"
DEMO_DIR="${CURRENT_DIR}/.."
SIND_CLUSTERNAME=dockercon
DOCKER_IMAGE_NAME="containous/${SIND_CLUSTERNAME}"
export DOCKER_HOST=""

pushd "${DEMO_DIR}"

# Build local dockerEE docker image
docker build -t "${DOCKER_IMAGE_NAME}" --no-cache "${DEMO_DIR}/dockeree"

# Prepare Docker Images
docker build -t containous/webapp-webbuilder --target=webbuilder ./webapp/
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
    --ports 6443:6443 \
    "${DOCKER_IMAGE_NAME}"

# Connect your docker cli to the docker swarm daemon:
eval "$(sind env --cluster="${SIND_CLUSTERNAME}")"

# Load cached images
sind push --timeout=240s --cluster="${SIND_CLUSTERNAME}" containous/whoami
sind push --timeout=240s --cluster="${SIND_CLUSTERNAME}" containous/webapp:latest

# Copy data inside sind:
echo "== Copying data inside TraefikEE..."
for CONTAINER in $(docker node ls --format="{{.Hostname}}")
do
    DOCKER_HOST="" docker exec "${CONTAINER}" sh -c "rm -rf /shared-data && mkdir /shared-data" \
        && DOCKER_HOST="" docker cp "${DEMO_DIR}/administration/grafana" "${CONTAINER}":/shared-data/ \
        && DOCKER_HOST="" docker cp "${DEMO_DIR}/administration/prometheus" "${CONTAINER}":/shared-data/ &
done
wait

# Create custom docker config for UCP installation:
docker config create com.docker.ucp.config "${DEMO_DIR}/dockeree/ucp.toml"

# Install UCP:
DOCKER_HOST="" docker exec -ti -e UCP_LICENSE="${DOCKEREE_CONTAINOUS_LICENSE}" "${SIND_CLUSTERNAME}-manager-0" \
    docker container run --rm -it -e UCP_LICENSE --name ucp --security-opt label=disable \
        -v /var/run/docker.sock:/var/run/docker.sock docker/ucp:3.1.6 \
            install --force-insecure-tcp --admin-username=admin --admin-password=adminpowpow --existing-config


# Download bundle to access to UCP with docker CLI and kube CLI:
rm -rf "${DEMO_DIR}"/dockeree/bundle.zip "${DEMO_DIR}"/dockeree/ucp-bundle
# Create an environment variable with the user security token
AUTHTOKEN=$(curl -sk -d '{"username":"admin","password":"adminpowpow"}' https://127.0.0.1:8443/auth/login | jq -r .auth_token)
# Download the client certificate bundle
curl -k -H "Authorization: Bearer $AUTHTOKEN" https://127.0.0.1:8443/api/clientbundle -o "${DEMO_DIR}"/dockeree/bundle.zip
# Unzip the bundle.
unzip "${DEMO_DIR}"/dockeree/bundle.zip -d "${DEMO_DIR}"/dockeree/ucp-bundle

# Run the utility script.
pushd "${DEMO_DIR}"/dockeree/ucp-bundle
eval "$(<env.sh)"
popd

echo "== DockerEE cluster ready: You can access to the webui at https://127.0.0.1:8443/login/ (Credentials: admin/adminpowpow)"

exit 0
