#!/bin/bash

# TraefikEE demo

# Save docker images:

#mkdir -p /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/images
#docker save containous/traefikee:demo -o /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/images/traefikee-demo.tar
#docker save containous/traefikee-private:latest -o /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/images/traefikee-private-latest.tar
#docker save containous/traefikee:latest -o /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/images/traefikee-latest.tar
#docker save rancher/local-path-provisioner:v0.0.4 -o /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/images/local-path-provisioner.tar
#docker save gcr.io/kubernetes-helm/tiller:v2.11.0 -o /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/images/tiller.tar

# Start k3s cluster:
docker-compose -f /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/docker-compose.yaml up -d server node
docker-compose -f /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/docker-compose.yaml scale node=2


# Use the correct kube config file:
export KUBECONFIG=/tmp/k3s-output/kubeconfig.yaml


# Create a local path storage:
kubectl --kubeconfig="${KUBECONFIG}" apply -f /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/k3s/local-path-storage.yaml
kubectl --kubeconfig="${KUBECONFIG}" patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# Install monitoring, tracing, whoami, hotrod:
kubectl apply -f /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/monitoring/
kubectl apply -f /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/tracing/
kubectl apply -f /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/whoami/
kubectl apply -f /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/hotrod/

docker-compose -f /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/docker-compose.yaml up -d traefik