#!/bin/bash

set -eu -o pipefail

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd -P)"
DEMO_DIR="${CURRENT_DIR}/.."
NAME="maesh"

pushd "${DEMO_DIR}"

# Prepare Docker Images
docker build -t containous/app-demo:latest ./apps/app1

# Create k3s cluster
k3d create \
--name="${NAME}" \
--workers="1" \
--publish="80:80" \
--publish="443:443" \
--publish="8080:8080" --server-arg="--no-deploy=traefik" --server-arg="--no-deploy=coredns"


k3d import-images --name="${NAME}" containous/whoami:v1.0.1
k3d import-images --name="${NAME}" containous/app-demo:latest

echo "== Waiting for cluster being ready"
sleep 10

KUBECONFIG="$(k3d get-kubeconfig --name="${NAME}")"
export KUBECONFIG

# Install Helm
echo 'apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system'| kubectl --kubeconfig="${KUBECONFIG}" apply -f -
helm init --service-account tiller --upgrade

# Install core dns
kubectl --kubeconfig="${KUBECONFIG}" apply -f ${DEMO_DIR}//k3s/coredns.yaml

# Install local-path-storage
kubectl --kubeconfig="${KUBECONFIG}" apply -f "${DEMO_DIR}/k3s/local-path-storage.yaml"
kubectl --kubeconfig="${KUBECONFIG}" patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

### Install CRDs

kubectl --kubeconfig="${KUBECONFIG}" apply -f "${DEMO_DIR}/crds/maesh"
kubectl --kubeconfig="${KUBECONFIG}" apply -f "${DEMO_DIR}/crds/traefik"

echo "== K3s cluster ready"

exit 0
