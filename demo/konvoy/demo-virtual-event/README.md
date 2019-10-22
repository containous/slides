
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

## Demo 1

### Tour

* Open Operation Portal
* Open all the sub dashboard
* Do a tour of Traefik Dashboard

### Demo Application

* Deploy it with `kubectl apply -f ./webapp/`

* Docker image can be rebuilts with content from `./webapp/docker-image`

## Demo 2
