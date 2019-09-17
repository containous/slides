
# Script

## integrated Traefik
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
kubectl get pods -n kube-system
kubectl logs -n kube-system <helm install pod>
```

- Show Service

```shell
kubectl get svc traefik --namespace kube-system
```

- Show Pods
```shell
kubectl get pods --namespace kube-system
```

- Apply configmap / service to expose dashboard & kill pod to reuse the new configmap

```shell
kubectl apply -f traefik-v1/traefik/basic
kubectl delete pod <name> -n kube-system
```

- Open TraefikEE dashboard at <http://localhost:8000/dashboard/>

- Lets move it to an ingress now

```shell
kubectl apply -f traefik-v1/traefik/dashboard-ingress
```
- Open TraefikEE dashboard at <http://dashboard.traefik.localhost/>

- Now we deploy our "webapplication":

```shell
kubectl apply -f webapp/
```

Available at <http://webapp.docker.localhost>

- Now we deploy the "backend cities":

```shell
kubectl apply -f webapp/cities
```

Check at <http://webapp.docker.localhost>: the 3 cities appear on the bottom + NYC has 2 replicas.


## Live Demo End 2 End Test
 
- On Mac: 

-- Go To TraefikEE dir

```shell
export TMPDIR=/tmp
make e2e-nobuild TESTS="kubernetes/oneline-single-cn-install.bats"
```