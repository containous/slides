
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
  --kubernetes.helmvaluespath=./traefikee/values.yaml
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
traefikeectl acme-add-account  --use --email=manuel@containo.us --clustername=k8s --name=powpow --caserver=https://pebble.pebble.svc.cluster.local/dir
traefikeectl deploy --clustername=k8s \
    --defaultentrypoints=http,https \
    --entryPoints='Name:http Address::80' \
    --entryPoints='Name:https Address::443 TLS' \
    --logLevel=INFO \
    --kubernetes \
    --acme.OverrideCertificates=true \
    --acme.entryPoint="https" --acme.httpChallenge.entrypoint=http \
    --acme.onHostRule=true \
    --acme.ACMELogging=true
    --tracing.backend="jaeger" \
    --tracing.jaeger.LocalAgentHostPort="jaeger-agent.jaeger.svc.cluster.local:6831" \
    --tracing.jaeger.SamplingServerURL="http://jaeger-agent.jaeger.svc.cluster.local:5778/sampling" \
    --metrics.prometheus
```
