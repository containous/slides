
# Demo D2IQ Virtual Event

## Installation Notes

* (Required only once): Create the initial `cluster.yaml` file
(from <https://docs.d2iq.com/ksphere/konvoy/latest/tutorials/provision-a-custom-cluster/>):

```shell
konvoy init --provisioner=aws
```

* Edit `cluster.yaml` to your needs (switched to 2 worker node only). We want to use us-west-1.

* Start cluster with `konvoy up`
