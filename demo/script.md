
# Script

## Integrated Traefik

- Requirement: make sure that `localhost`, `dashboard.traefik.localhost` and `webapp.traefik.localhost`
are pointing to your Docker Engine

- We will have a k3s platform, so install it

```shell
k3d create \
--name="demo" \
--workers="1" \
--publish="80:80" \
--publish="8080:8080"
```

- Now, configure access:

```shell
export KUBECONFIG="$(k3d get-kubeconfig --name='demo')"
```

- Check that it worked and Traefik is installed by default

```shell
kubectl get nodes
kubectl get pods --namespace kube-system
kubectl logs --namespace kube-system <helm install pod>
```

- Show Service

```shell
kubectl get svc --namespace kube-system traefik
```

- Show Pods

```shell
kubectl get pods --namespace kube-system
```

- Apply configmap / service to expose dashboard & kill pod to reuse the new configmap

```shell
kubectl apply -f traefik-v1/traefik/basic
kubectl delete pod --namespace kube-system <name>
```

- Open TraefikEE dashboard at <http://localhost:8080/dashboard/>

- Lets move it to an ingress now

```shell
kubectl apply -f traefik-v1/traefik/dashboard-ingress
```

- Open TraefikEE dashboard at <http://dashboard.traefik.localhost/>

- Now developement team want deploy their "webapplication".
Start by building the webapp image and pushing it to the k3s cluster:

```shell
docker build -t containous/webapp ./traefik-v1/webapp/build/
k3d import-images containous/webapp --name=demo
```

- Then deploy the application on the cluster:

```shell
kubectl apply -f traefik-v1/webapp/
```

Available at <http://webapp.docker.localhost>

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
