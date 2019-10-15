
# Script

## With Traefik V2

### Install required CRDs

```shell
kubectl apply -f crds/traefik
```

### Install monitoring, tracing, mysql 

```shell
kubectl apply -f monitoring/
kubectl apply -f jaeger/
```

### Install traefik

```shell
kubectl apply -f traefik/
```

Open Traefik v2 dashboard at <http://dashboard.docker.localhost>

### Install Maesh

- Now we add our helm chart for maesh:

```shell
helm repo add maesh https://containous.github.io/maesh/charts
```

If helm has not been used, you need to initialize tiller:

```shell
helm init
```

Next, we install it:

```shell
helm repo update
helm install --name=maesh --namespace=maesh maesh/maesh --values=./maesh/values.yaml
```

### Install custom applications

- We may need to build the image if not already built:

```shell
kubectl apply -f google/
```

