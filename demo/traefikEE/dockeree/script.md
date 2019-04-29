
# Script

- We have a Swarm platform. Configure access to this platform:

```shell
eval $(sind env --cluster=dockercon)
```

- Let's add a Traefikee cluster to Swarm as Ingress:

```shell
traefikeectl install \
    --clustername=swarm \
    --swarm \
    --controlnodes=3 \
    --dashboard \
    --licensekey="${TRAEFIKEE_LICENSE_KEY}"
```

Open TraefikEE dashboard at <http://localhost:8080>

- Now we deploy our "webapplication":

```shell
docker stack deploy --compose-file=./apps/webapp.yml webapp
```

Available at <http://localhost>

- Now we deploy the "backend cities":

```shell
docker stack deploy --compose-file=./apps/sf.yml sf
docker stack deploy --compose-file=./apps/paris.yml paris
docker stack deploy --compose-file=./apps/nyc.yml nyc
```

Check at <http://localhost>: the 3 cities appear on the bottom + NYC has 2 replicas.

- Deploy the "administration" stack:

```shell
docker stack deploy --compose-file=./administration/monitoring.yml monitoring
docker stack deploy --compose-file=./administration/tracing.yml tracing
```

- Configure TraefikEE to report to the administration stack:

```shell
traefikeectl deploy --clustername=swarm \
    --defaultentrypoints=http,https \
    --entryPoints='Name:http Address::80' \
    --entryPoints='Name:https Address::443 TLS' \
    --logLevel=INFO \
    --docker.swarmmode \
    --tracing.backend="jaeger" \
    --tracing.jaeger.LocalAgentHostPort="jaeger:6831" \
    --tracing.jaeger.SamplingServerURL="http://jaeger:5778/sampling"
```

- Open the "Hotrod" application (<http://hotrod.localhost>) and click buttons to generate requests to the micro services

- Open Jaeger UI to track requests, at (<http://jaeger.localhost>)

- Open grafana UI at (<http://grafana.localhost/d/traefik/traefik?orgId=1>)
