
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

Open Traefik v2 dashboard at <https://dashboard.docker.localhost>

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

- Dema based on https://github.com/GoogleCloudPlatform/microservices-demo

```shell
kubectl apply -f google/ad.yaml
kubectl apply -f google/checkout.yaml
kubectl apply -f google/currency.yaml
kubectl apply -f google/email.yaml
kubectl apply -f google/frontend.yaml
kubectl apply -f google/payment.yaml
kubectl apply -f google/productcatalog.yaml
kubectl apply -f google/recommendation.yaml
kubectl apply -f google/shipping.yaml

kubectl apply -f google/ingress.yaml

kubectl apply -f google/redis.yaml
kubectl apply -f google/cart.yaml

kubectl apply -f google/load.yaml
```

- Dashboard avaialble at https://grafana.docker.localhost

- Application available at https://frontent.docker.localhost
