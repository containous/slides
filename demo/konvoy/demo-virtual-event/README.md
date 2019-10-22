
# Demo D2IQ Virtual Event

## Installation Notes

* (Required only once): Create the initial `cluster.yaml` file
(from <https://docs.d2iq.com/ksphere/konvoy/latest/tutorials/provision-a-custom-cluster/>):

```shell
konvoy init
```

* Start the cluster (takes ~15 min) with

```shell
konvoy up --yes
```

* Retrieve the kubeconfig with:

```shell
konvoy apply kubeconfig
# (...)
kubectl get nodes
```

## Demo 1 (Traefik v1)

### Tour

* Open Operation Portal
* Open all the sub dashboard
* Do a tour of Traefik Dashboard

### Demo Application

* Deploy it with `kubectl apply -f ./webapp/`

* Docker image can be rebuilts with content from `./webapp/docker-image`

## Demo 2 (Traefik v2)

### Retrieve Traefik v1 Configurations

* Retrieve static configuration:

```shell
kubectl get pod --namespace=kubeaddons traefik-kubeaddons-6485fb848b-4l99w -o yaml > traefik-v1/deployment.yml
kubectl get configmaps --namespace=kubeaddons traefik-kubeaddons -o yaml > ./traefik-v1/configmap.yml
```

* Extract the TOMl from `./traefik-v1/configmap.yml` and copy it into `./traefik-v1/traefik.toml`

* Retrieve Dynamic configuration:

```shell
kubectl get ingress --all-namespaces -o yaml > ./traefik-v1/ingresses.yml
```

### Convert Configuration for v2

* Download <https://github.com/containous/traefik-migration-tool> (v0.9.0 used)

* Convert static configuration:

```shell
traefik-migration-tool static --input=./traefik-v1/traefik.toml --output-dir=./traefik-v2/
```

* Convert dynamic configuration (ingresses to ingressroutes):

```shell
traefik-migration-tool ingress --input=./traefik-v1/ingresses.yml --output=./traefik-v2/
```

### Fix Configuration issues (aka. what the migration tool did not worked out)

* Find every object names in `./traefik-v2/ingresses.yml` containing a slash (`/`) and replace it by a dash (or remove it when it's leading or trailing):

```shell
sed 's#name: \/\(.*\)\/\(.*\)\/\(.*\)$#name: \1-\2-\3#g' ./traefik-v2/ingresses.yml > ./traefik-v2/ingressroutes.yml
```

### Install Traefik v2

* Get the Helm Chart

TODO

* Specify custom values:

```yml
# values.yaml
```

* Install it with the following:

```shell
helm install --values=values.yaml ./traefik-helm-chart/
```

### Create IngressRoutes

* Apply the new Ingress routes:

```shell

```

* (If you forgot, remove the legacy dashboard IngressRoute):

```shell
kubectl delete --namespace=kubeaddons ingressroute traefik-kubeaddons-dashboard
```

## Demo 3 (Maesh)

* Install Maesh:

```shell
helm repo add maesh https://containous.github.io/maesh/charts
helm repo update
helm install --name=maesh --namespace=maesh maesh/maesh --values=./maesh/values.yaml
```

* Install SMI CRDs:

```shell
kubectl apply -f ./maesh/crds/
```

* Install demo app

```shell
kubectl apply -f apps/0-namespace.yaml
kubectl apply -f apps/1-sas.yaml
kubectl apply -f apps/2-apps-client.yaml
kubectl apply -f apps/3-apps-servers.yaml
kubectl apply -f apps/4-ingress.yaml
```
