# TraefikEE demo K3s

## Requirements

- Docker Engine 18.09.3+
- The command line tool `teectl` 2.0.0+ (download from <https://docs.containo.us/>)
- A bash interpreter with basic tooling like `curl`, `tar` and `unzip`
- A local DNS resolution (editing `/etc/hosts` is enough),
  with the following hostname pointing to your Docker Engine's IP
  (`127.0.0.1` for Docker local Engine or Docker4Mac, `minikube ip` or `docker-machine ip` for sinners):
  - `prometheus.docker.localhost`
  - `grafana.docker.localhost`
  - `jaeger.docker.localhost`
  - `hotrod.docker.localhost`
- K3d

## Quick Start

- Start the cluster with the command `bash ./scripts/run.sh`. This script will execute the following steps:
  - Ensure all requirements are met on your machine

- Now, run the scenario described in [the `script.md`](./script.md)

## Problem or Cleanup

In case of any issue:

- Restart your Docker Engine

