
# Script

- We have a k3s platform. Configure access to this platform:

```shell
export KUBECONFIG=/tmp/k3s-output/kubeconfig.yaml
```

- Let's add a Traefikee cluster to k3s as Ingress:

```shell
traefikeectl install \
  --clustername=k8s \
  --licensekey=$TRAEFIKEE_LICENSE_KEY \
  --dashboard \
  --dashboard.insecure \
  --force \
  --kubernetes \
  --kubernetes.helmvaluespath=./traefikee/values.yaml
```

Open TraefikEE dashboard at <http://dashboard.docker.localhost>

- Now we deploy our "webapplication":

```shell
kubectl --kubeconfig="${KUBECONFIG}" apply -f webapp/
```

Available at <http://webapp.docker.localhost>

- Now we deploy the "backend cities":

```shell
kubectl --kubeconfig="${KUBECONFIG}" apply -f webapp/cities
```

Check at <http://webapp.docker.localhost>: the 3 cities appear on the bottom + NYC has 2 replicas.

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
    --acme.email="michael@containo.us" \
    --acme.keyType="EC384" \
    --acme.OverrideCertificates=true \
    --acme.entryPoint="https" --acme.httpChallenge.entrypoint=http \
    --acme.onHostRule=true \
    --acme.ACMELogging=true \
    --acme.caServer='https://pebble.pebble.svc.cluster.local/dir'
```

- Open the "Hotrod" application (<http://hotrod.docker.localhost>) and click buttons to generate requests to the micro services

- Open Jaeger UI to track requests, at (<http://jaeger.docker.localhost>)

- Open grafana UI at (<http://grafana.docker.localhost/d/traefik/traefik?orgId=1>)
