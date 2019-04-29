# TraefikEE demo Docker EE

## Requirements

- Docker Engine 18.09.3+
- The command line tool `traefikeectl` 1.0.0+ (download from <https://docs.containo.us/>)
- A bash command line with `curl`, `tar` and `unzip`
- [sind](https://github.com/jlevesy/sind#installation) v0.3.0+
- [slapper](https://github.com/ikruglov/slapper) (Install with `go get -u github.com/ikruglov/slapper`)
- A local DNS resolution (editing `/etc/hosts` is enough),
  with the following hostname pointing to your Docker Engine's IP
  (`127.0.0.1` for Docker local Engine or Docker4Mac, `minikube ip` or `docker-machine ip` for sinners):
  - `prometheus.localhost`
  - `grafana.localhost`
  - `jaeger.localhost`
  - `hotrod.localhost`

## Quick Start

- Start the cluster with the command `bash ./scripts/run.sh`. This script will execute the following steps:
  - Ensure all requirements are met on your machine
  - Create a Swarm cluster using [sind](https://github.com/jlevesy/sind#installation)

- Now, run the scenario described in [the `SCRIPT.md`](./SCRIPT.md)

## Problem or Cleanup

In case of any issue:

- Restart your Docker Engine

You might want to cleanup at the end (or when running into issues):

- Run the script `bash ./scripts/clean.sh`
