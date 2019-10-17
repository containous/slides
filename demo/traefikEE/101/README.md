# Demo 101 TraefikEE

* Update your `/etc/hosts`:

```text
...
127.0.0.1   app.traefikee.io dashboard.traefikee.io
```

* Prepare the environment:

```shell
bash ./prepare.sh
```

* Open dashboard at <http://dashboard.traefikee.io/dashboard/> and browse to metrics tab

* Open the webapp at <http://app.traefikee.io>

* Deploy the microservices:

```shell
export KUBECONFIG="$(k3d get-kubeconfig --name='demo')"
kubectl get pod --namespace=webapp
kubectl apply -f ./webapp/cities/
kubectl get pod --namespace=webapp
```

* Check the webapp at <http://app.traefikee.io> and see the services that appeared

* Check the dashboard, with metrics working

* Switch to config and then to cluster view
