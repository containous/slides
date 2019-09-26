
# Script

## Preparations TraefikEE

- Let's add a Traefikee cluster to the platform 9 cluster

```shell
traefikeectl install \
  --clustername=kubernetes-days \
  --licensekey=${TRAEFIKEE_LICENSE_KEY} \
  --dashboard \
  --dashboard.insecure \
  --force \
  --kubernetes \
  --kubernetes.helmvaluespath=./traefikee/values.yaml
```

```shell
kubectl apply -f pebble/
kubectl apply -f monitoring/
kubectl apply -f jaeger/
kubectl apply -f hotrod/
kubectl apply -f crds/maesh
```

Run K3s script

```shell
./scripts/run.sh
``` 

Connect kubectl with local cluster
```
KUBECONFIG="$(k3d get-kubeconfig --name="maesh")"
export KUBECONFIG
```

## K3s TraefikEE

- Let's add a Traefikee cluster to the k3s cluster

```shell
traefikeectl install \
  --clustername=k8s \
  --licensekey=${TRAEFIKEE_LICENSE_KEY} \
  --dashboard \
  --dashboard.insecure \
  --force \
  --kubernetes \
  --kubernetes.helmvaluespath=./traefikee/values.yaml
```

### Install pebble, monitoring, tracing, whoami, hotrod 

- Connect to the live cluster again

```KUBECONFIG="/Users/manuelzapf/Downloads/pmk001.yml"
export KUBECONFIG
```

```shell
traefikeectl list-nodes --clustername=kubernetes-days
```

Open TraefikEE dashboard at <http://platform9.traefikee-demo.containous.cloud/>

- Now we deploy our "webapplication":

```shell
kubectl apply -f webapp
```

Available at <http://webapp.platform9.traefikee-demo.containous.cloud>


- Now we deploy the "backend cities":

```shell
kubectl apply -f webapp/cities
```

Check at <http://webapp.platform9.traefikee-demo.containous.cloud>: the 3 cities appear on the bottom + NYC has 2 replicas.
```

- Configure TraefikEE to report to the administration stack:

```shell
traefikeectl deploy --clustername=k8s \
    --defaultentrypoints=http,https \
    --entryPoints='Name:http Address::80' \
    --entryPoints='Name:https Address::443 TLS' \
    --logLevel=INFO \
    --kubernetes \
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

Open Apps at <http://apps.platform9.traefikee-demo.containous.cloud>

You can see that only two images are available because by default SMI block all communication in the maesh.

We will now apply HTTPRouteGroup and TrafficTarget to allow communications between apps-client and apps-server

```shell
kubectl apply -f apps/5-hrgs.yaml
kubectl apply -f apps/6-tts.yaml
```

After few seconds (maybe minutes depending of your kubernetes cluster) you will be able to refresh the page <http://apps.platform9.traefikee-demo.containous.cloud> and see 4 images.
The first two images are fetched/retrieved through the maesh.