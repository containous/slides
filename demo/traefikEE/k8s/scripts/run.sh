#!/bin/bash

set -eu -o pipefail

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd -P)"
DEMO_DIR="${CURRENT_DIR}/.."
IMAGE_DIR="${DEMO_DIR}/images"
SIND_CLUSTERNAME=dockerswarm
DOCKER_IMAGE_NAME="containous/${SIND_CLUSTERNAME}"
export DOCKER_HOST=""

pushd "${DEMO_DIR}"

# Prepare Docker Images
docker build -t containous/webapp ./webapp/build
docker pull containous/whoami

mkdir -p ${IMAGE_DIR}
docker save containous/webapp -o ${IMAGE_DIR}/webapp.tar
docker save store/containous/traefikee:v1.0.0 -o ${IMAGE_DIR}/traefikee.tar

# Create k3s cluster
docker-compose --file ${DEMO_DIR}/docker-compose.yaml up -d --scale node=2

# Use correct KUBECONFIG file
export KUBECONFIG=/tmp/k3s-output/kubeconfig.yaml

echo "== Waiting for cluster being ready"
sleep 10

kubectl --kubeconfig="${KUBECONFIG}" apply -f ${DEMO_DIR}/k3s/coredns.yaml
kubectl --kubeconfig="${KUBECONFIG}" apply -f ${DEMO_DIR}//k3s/local-path-storage.yaml
kubectl --kubeconfig="${KUBECONFIG}" patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# Install pebble, monitoring, tracing, whoami, hotrod 

kubectl --kubeconfig="${KUBECONFIG}" apply -f pebble/
kubectl --kubeconfig="${KUBECONFIG}" apply -f monitoring/
kubectl --kubeconfig="${KUBECONFIG}" apply -f jaeger/
kubectl --kubeconfig="${KUBECONFIG}" apply -f whoami/
kubectl --kubeconfig="${KUBECONFIG}" apply -f hotrod/

echo "== K3s cluster ready"

exit 0
