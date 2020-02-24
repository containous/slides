
# Script

## With TraefikEE

- Let's add a Traefikee cluster to k3s as Ingress:

```shell
traefikeectl install \
  --clustername=k8s \
  --licensekey=${TRAEFIKEE_LICENSE_KEY} \
  --dashboard \
  --dashboard.insecure \
  --force \
  --kubernetes \
  --kubernetes.helmvaluespath=./traefikee/values.yaml \
```

### Install pebble, monitoring, tracing, whoami, hotrod 

```shell
kubectl apply -f pebble/
kubectl apply -f monitoring/
kubectl apply -f jaeger/
kubectl apply -f hotrod/
```

Open TraefikEE dashboard at <http://dashboard.docker.localhost>

- Now we deploy our "webapplication":

```shell
kubectl apply -f webapp
```

Available at <http://webapp.docker.localhost>


- Now we deploy the "backend cities":

```shell
kubectl apply -f webapp/cities
```

Check at <http://webapp.docker.localhost>: the 3 cities appear on the bottom + NYC has 2 replicas.
```

- Configure TraefikEE to report to the administration stack:

```shell
traefikeectl acme-add-account  --use --email=michael@containo.us --clustername=k8s --name=powpow --caserver=https://pebble.pebble.svc.cluster.local/dir
traefikeectl deploy --clustername=k8s \
    --defaultentrypoints=http,https \
    --entryPoints='Name:http Address::80' \
    --entryPoints='Name:https Address::443 TLS' \
    --logLevel=INFO \
    --kubernetes \
    --acme.OverrideCertificates=true \
    --acme.entryPoint="https" --acme.httpChallenge.entrypoint=http \
    --acme.domains=webapp.docker.localhost \
    --acme.ACMELogging=true
    --tracing.backend="jaeger" \
    --tracing.jaeger.LocalAgentHostPort="jaeger-agent.jaeger.svc.cluster.local:6831" \
    --tracing.jaeger.SamplingServerURL="http://jaeger-agent.jaeger.svc.cluster.local:5778/sampling" \
    --metrics.prometheus
```

- Now we add our helm chart for maesh:

```shell
helm repo add maesh https://containous.github.io/maesh/charts
```

Next, we install it:

```shell
helm repo update
helm install --name=maesh --namespace=maesh maesh/maesh --values=./maesh/values.yaml
```

- Now we install the custom app to show SMI

```shell
kubectl apply -f apps/0-namespace.yaml
kubectl apply -f apps/1-sas.yaml
kubectl apply -f apps/2-apps-client.yaml
kubectl apply -f apps/3-apps-servers.yaml
kubectl apply -f apps/4-ingress.yaml
```

Open Apps at <http://apps.docker.localhost>

You can see that only two images are available because by default SMI block all communication in the maesh.

We will now apply HTTPRouteGroup and TrafficTarget to allow communications between apps-client and apps-server

```shell
kubectl apply -f apps/5-hrgs.yaml
kubectl apply -f apps/6-tts.yaml
```

After few seconds (maybe minutes depending of your kubernetes cluster) you will be able to refresh the page <http://apps.docker.localhost> and see 4 images.
The first two images are fetched/retrieved through the maesh.


## With Traefik V2

### Install required CRDs

```shell
kubectl apply -f crds/maesh
kubectl apply -f crds/traefik
```

### Install monitoring, tracing, hotrod 

```shell
kubectl apply -f monitoring/
kubectl apply -f jaeger/
kubectl apply -f hotrod/
```

### Install traefik

```shell
kubectl apply -f traefik/
```

Open Traefik v2 dashboard at <http://dashboard.docker.localhost>

### Install Maesh with SMI

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

helm install maesh maesh/maesh --values=./maesh/values.yaml --version=1.1.0-rc1

kubectl port-forward --address 0.0.0.0 pod/maesh-controller-6788c5967d-wsvgw 9000:9000



```

### Install custom applications

- We may need to build the image if not already built:

```shell
docker build -t containous/app-demo:latest ./apps/app1
```

Then create the application objects

```shell
kubectl apply -f apps/0-namespace.yaml
kubectl apply -f apps/1-sas.yaml
kubectl apply -f apps/2-apps-client.yaml
kubectl apply -f apps/3-apps-servers.yaml
kubectl apply -f apps/4-ingress.yaml
```

Open Apps at <http://apps.docker.localhost>

You can see that only two images are available because by default SMI block all communication in the maesh.

We will now apply HTTPRouteGroup and TrafficTarget to allow communications between apps-client and apps-server

```shell
kubectl apply -f apps/5-hrgs.yaml
kubectl apply -f apps/6-tts.yaml
```

After few seconds (maybe minutes depending of your kubernetes cluster) you will be able to refresh the page <http://apps.docker.localhost> and see 4 images.
The first two images are fetched/retrieved through the maesh.
