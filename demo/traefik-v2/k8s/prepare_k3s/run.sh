#!/bin/bash

set -eu -o pipefail

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd -P)"
DEMO_DIR="${CURRENT_DIR}/.."
NAME="kubecon"

pushd "${DEMO_DIR}"

# Cleanup old cluster, never errors
bash "${CURRENT_DIR}/clean.sh" || true

# Create k3s cluster
k3d create \
--name="${NAME}" \
--workers="2" \
--publish="80:80" \
--publish="443:443" \
--server-arg="--no-deploy=traefik"

echo "== Loading Image Cache"
while IFS= read -r LINE
do
  image_name="$(echo "${LINE}" | cut -d'|' -f2)"
  k3d import-images --name="${NAME}" "${image_name}"
done < <(cat "${CURRENT_DIR}/images_list")

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

# Patch CoreDNS to be able to intercept Pebble/ACME requests
kubectl --kubeconfig="${KUBECONFIG}" get configmap -n kube-system coredns -o yaml \
  | awk '{sub(/health$/,"health\n        rewrite name regex (.*)\\.localhost traefik-ingress-controller.traefik.svc.cluster.local")}1' \
  | kubectl --kubeconfig="${KUBECONFIG}" apply -f -

echo "== K3s cluster ready"

exit 0
