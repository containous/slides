
# Script

## Integrated Traefik

- Requirement: make sure that `localhost`, `dashboard.traefik.localhost` and `webapp.traefik.localhost`
are pointing to your Docker Engine

### From Zero To Webapp

- We need a k3s platform, so install it:

```shell
k3d create \
--name="demo" \
--workers="1" \
--publish="80:80"
```

- Now, configure access to the Kubernetes API:

```shell
export KUBECONFIG="$(k3d get-kubeconfig --name='demo')"
```

- Check that it worked and Traefik is installed by default (might take a few seconds)

```shell
kubectl get nodes
kubectl get pods --namespace kube-system
kubectl logs --namespace kube-system <helm install pod>
```

- Show Service

```shell
kubectl get svc --namespace kube-system traefik
```

- Open the web page at <http://webapp.docker.localhost>: it says `404 Not Found`,
which means no applications deployed yet but Traefik Ingress already setup (HTTP answer).

- Then deploy the application on the cluster:

```shell
kubectl apply -f traefik-v1/webapp/
```

Available at <http://webapp.docker.localhost>

### Tuning Traefik

- Show Pods

```shell
kubectl get pods --namespace kube-system
```

- Apply configmap / service to expose dashboard as ingress & kill pod to reuse the new configmap

```shell
kubectl apply -f traefik-v1/traefik/dashboard-ingress
kubectl delete pod --namespace kube-system <name>
```

- Open TraefikEE dashboard at <http://dashboard.traefik.localhost/>

### Dynamic Routing

- Now we deploy the "backend cities":

```shell
kubectl apply -f traefik-v1/webapp/cities/
```

Check at <http://webapp.docker.localhost>: the 3 cities appear on the bottom and NYC + Paris have 2 replicas each.

## Live Demo End 2 End Test

- On Mac:

-- Go To TraefikEE dir

```shell
export TMPDIR=/tmp
make e2e-nobuild TESTS="kubernetes/oneline-single-cn-install.bats"
```
