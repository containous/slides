#!/bin/bash

set -eux -o pipefail

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd -P)"
NAME="demo"

bash "${CURRENT_DIR}/clean.sh"

# Create k3s cluster
k3d create \
--name="${NAME}" \
--workers="3" \
--publish="80:80" \
--publish="8080:8080" \
--server-arg="--no-deploy=traefik"

echo "== Waiting for cluster being ready"
sleep 10

KUBECONFIG="$(k3d get-kubeconfig --name="${NAME}")"
export KUBECONFIG

# Install local-path-storage
kubectl --kubeconfig="${KUBECONFIG}" apply -f "${CURRENT_DIR}/local-path-storage.yml"
kubectl --kubeconfig="${KUBECONFIG}" patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

echo "== K3s cluster ready"

echo "== Install TraefikEE"
traefikeectl install \
  --clustername=demo \
  --licensekey="${TRAEFIKEE_LICENSE_KEY}" \
  --dashboard \
  --dashboard.insecure \
  --force \
  --controlnodes=3 \
  --datanodes=3 \
  --kubernetes \
  --kubernetes.helmvaluespath=./traefikee.yml

echo "== Deploy default webapp"
kubectl apply -f "${CURRENT_DIR}/webapp/"

exit 0
