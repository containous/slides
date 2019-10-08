
# Script

## With Traefik V2

### Install required CRDs

```shell
kubectl apply -f crds/maesh
kubectl apply -f crds/traefik
```

### Install monitoring, tracing, mysql 

```shell
kubectl apply -f monitoring/
kubectl apply -f jaeger/
kubectl apply -f mysql/
kubectl run -it --rm --image=mysql:5.6 --restart=Never mysql-client -- mysql -uroot -ppetclinic -h mysql.mysql.svc.cluster.local
create database petclinic;
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
helm install --name=maesh --namespace=maesh maesh/maesh --values=./maesh/values.yaml
```

### Install custom applications

- We may need to build the image if not already built:

```shell
docker build -t containous/app-demo:latest ./apps/app1
k3d import-images --name="maesh" containous/app-demo:latest
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

#### Whoami

Deploy whoami service

```bash
kubectl apply -f whoami/
```

Call whoami without the maesh

```bash
kubectl -n whoami exec whoami-client -- curl -s whoami.whoami.svc.cluster.local
Hostname: whoami-56d989fbcf-grk9w
IP: 127.0.0.1
IP: ::1
IP: 10.42.0.35
IP: fe80::58da:e7ff:fe67:d5ab
GET / HTTP/1.1
Host: whoami.whoami.svc.cluster.local
User-Agent: curl/7.64.0
Accept: */*
```

Call whoami through the maesh

```bash
kubectl -n whoami exec whoami-client -- curl -s whoami.whoami.maesh
404 page not found
```

Call whoami tcp without the maesh

```bash
kubectl -n whoami exec -ti whoami-client -- nc whoami-tcp.whoami.svc.cluster.local 8080
hello
Received: hello
```

Call whoami tcp through the maesh

```bash
kubectl -n whoami exec -ti whoami-client -- nc whoami-tcp.whoami.maesh 8080
hello
Received: hello
```


### Note

/!\ Don't forget to update your `/etc/host` if your are on Mac

```
apps.docker.localhost         127.0.0.1
dashboard.docker.localhost    127.0.0.1
grafana.docker.localhost      127.0.0.1
jaeger.docker.localhost       127.0.0.1
hotrod.docker.localhost       127.0.0.1
whoami.docker.localhost       127.0.0.1
webapp.docker.localhost       127.0.0.1
```
