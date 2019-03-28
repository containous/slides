## Install traefikee:

```bash
traefikeectl install \
  --clustername=k8straefikee \
  --licensekey=$TRAEFIKEE_LICENSE_KEY \
  --dashboard \
  --dashboard.insecure \
  --force \
  --kubernetes \
  --kubernetes.helmvaluespath=/home/nicolas/go/src/github.com/containous/slides/demo/traefikee/values.yaml \
  --kubernetes.helmchart=/home/nicolas/go/src/github.com/containous/slides/demo/traefikee/helm
```

## Deploy a configuration:

```bash
traefikeectl deploy --clustername=k8straefikee \
--kubernetes \
--tracing.backend="jaeger" \
--tracing.jaeger.LocalAgentHostPort="jaeger-agent.tracing.svc.cluster.local:6831" \
--tracing.jaeger.SamplingServerURL="http://jaeger-agent.tracing.svc.cluster.local:5778/sampling"
```

## Run slapper

```bash
slapper -targets /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/slapper/whoami.target -minY 100ms -maxY 800ms -timeout 30s -rate 200
```

## Down K3S

```bash
docker-compose -f /home/nicolas/go/src/github.com/containous/advocacy/traefikee-demo/docker-compose.yaml down -v
```