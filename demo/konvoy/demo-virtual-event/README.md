
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

* Get public domain name with

```shell
konvoy get ops-portal
```

* Open Operation Portal
* Open all the sub dashboard
* Do a tour of Traefik Dashboard

### Demo Application

* Deploy it with:

```shell
kubectl apply -f ./demo1/webapp/
```

* Check Traefik dashboard: new backend + frontend

* Open application at `http://<CNAME>/webapp/`,
  and reload to see replicas

* Check Grafana for metrics in the traefik dashboard after some seconds

<!-- * Docker image can be rebuilts with content from `./webapp/docker-image` -->

## Demo 2 (Traefik v2)

### Install Traefik v2

* Helm chart is in the repo (frozen state). Otherwise get it at <https://github.com/containous/traefik-helm-chart>.

* Install it with the following:

```shell
helm install --namespace="traefik-v2" --name="traefik-v2" ./demo2/traefik-helm-chart/
```

* Wait for everything ready:

```shell
kubectl get all --namespace=traefik-v2
# Retrieve the external LB domain

dig <external LB domain>
# Wait for an answer with IP in the "IN A"
```

* Open the new dashboard at `http://<external LB domain>/dashboard/`

<!-- ### Retrieve Traefik v1 Configurations

* Retrieve static configuration:

```shell
kubectl get pod --namespace=kubeaddons traefik-kubeaddons-6485fb848b-4l99w -o yaml > traefik-v1/deployment.yml
kubectl get configmaps --namespace=kubeaddons traefik-kubeaddons -o yaml > ./demo1/configmap.yml
```

* Extract the TOMl from `./demo1/configmap.yml` and copy it into `./demo1/traefik.toml`

* Retrieve Dynamic configuration:

```shell
kubectl get ingress --all-namespaces -o yaml > ./demo1/ingresses.yml
```
-->

### Convert Configuration for v2

<!-- * Download <https://github.com/containous/traefik-migration-tool> (v0.9.0 used) -->

<!-- * Convert static configuration:

```shell
traefik-migration-tool static --input=./demo1/traefik.toml --output-dir=./demo2/
``` -->

* Convert dynamic configuration (ingresses to ingressroutes):

```shell
traefik-migration-tool ingress --input=./demo1/ingresses.yml --output=./migration/
```

<!-- ### Fix Configuration issues (aka. what the migration tool did not worked out)

* Find every object names in `./demo2/ingresses.yml` containing a slash (`/`) and replace it by a dash (or remove it when it's leading or trailing):

```shell
sed 's#name: \/\(.*\)\/\(.*\)\/\(.*\)$#name: \1-\2-\3#g' ./demo2/ingresses.yml > ./demo2/ingressroutes.yml
``` -->

### Create IngressRoutes

* Apply the new Ingress routes:

```shell
kubectl apply -f ./demo2/ingressroutes.yml
```

* Check the deployment in the dashboard

* Open the webapp at the new URL

<!--
* (If you forgot, remove the legacy dashboard IngressRoute):

```shell
kubectl delete --namespace=kubeaddons ingressroute traefik-kubeaddons-dashboard
``` -->

## Demo 3 (Maesh)

* Install Maesh:

```shell
helm repo add maesh https://containous.github.io/maesh/charts
helm repo update
helm install --name=maesh --namespace=maesh maesh/maesh --values=./demo3/values.yaml
```

* Install demo app

```shell
kubectl apply -f ./demo3/apps/0-apps/
```

<!-- * (Optionnal: demo app can be rebuilt from `./demo3/apps/docker-image`) -->

* Open the apps webpage at `http://<external LB>/maesh/`: only 2 images using the normal service network

* Deploy the SMI configuration

```shell
kubectl apply -f ./demo3/apps/1-smis/
```

## Cleanup

* Remove Helm deploments:

```shell
helm delete --purge maesh traefik-v2
```

* Remove namespaces (and the related resources):

```shell
kubectl delete namespaces apps webapp maesh traefik-v2
```
