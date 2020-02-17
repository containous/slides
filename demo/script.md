
# Script

- We have a kubernetes platform

## Prepare environment

IMPORTANT: Openshift(*) 4.2 is required!

From the page <https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/>. download:

- `openshift-client` archive which provides the command `oc`,
- `openshit-install` archive which provide the command `openshift-install`

Prepare your environment:

```bash
export OS_CLUSTER_NAME=meetup
export OS_CLUSTER_INSTALL_PATH="$(pwd)/${OS_CLUSTER_NAME}"
mkdir -p "${OS_CLUSTER_INSTALL_PATH}"
```

### Create installation configuration

```bash
openshift-install create install-config --dir="${OS_CLUSTER_INSTALL_PATH}"
? SSH Public Key>
? Platform> #(aws)
? Region> #eu-east-1
? Base Domain> #(From Route 53)
? Cluster Name>
? Pull Secret> # Ask @mmatur for this pull secret, coming from a redhat account
```

### Deploy cluster

```bash
openshift-install create cluster --dir="${OS_CLUSTER_INSTALL_PATH}" --log-level debug
```

### Manage security constraint

```
kubectl create namespace traefikee
oc create -f openshift/traefik-scc.yaml
oc adm policy add-scc-to-user traefik-scc -z default -n traefik
kubectl apply -f traefik/01-crd,yaml
```

## Deploy the stack

```bash
kubectl apply -f monitoring/
kubectl apply -f jaeger/
kubectl apply -f hotrod/
```

## Install Traefik

```bash
kubectl apply -f traefik/
```

## Install TraefikEE

```bash
teectl setup --cluster="meetup" --kubernetes --force
teectl setup gen --cluster="meetup" --license="${TRAEFIKEE_LICENSE}" --controllers=1 --proxies=2 | kubectl apply -f -

for item in $(kubectl -n traefikee get pods -l component=proxies --output=name); do
kubectl annotate -n traefikee ${item} prometheus.io/scrape='true';
kubectl annotate -n traefikee ${item} prometheus.io/port='8080';
done

teectl apply --cluster=meetup --file=./traefikee/config.toml
```

## Run Demo

Open Traefik dashboard at <http://dashboard.meetup.containous.tech>

Deploy the app-v1 (eg. the "production" application):

```
kubectl apply -f ./app/v1
```

Open the webapp application at <http://app.meetup.containous.tech> and reload it 4-5 times to show the changing IP (e.g. load balancer in action)

Deploy the app-v2 and set it to canary for 25% requests:


```
kubectl apply -f ./app/v2
```

Reload the webapp at <http://app.meetup.containous.tech>: you see the page changing.
