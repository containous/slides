# Install helm

Pull TraefikEE's image with docker pull (no auth used with helm)

Install tiller with:

`helm init --service-account default`

Deploy cluster with:

`helm install --name traefikee --namespace traefikee .`

Destroy the cluster with:

`helm del --purge traefikee`
