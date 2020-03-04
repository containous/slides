#!/bin/bash
set -o pipefail
set -o errexit

main() {
    check-tools
    setup-k3s

    prepare-docker-images

    # Install pebble, monitoring, tracing, whoami, hotrod
    readonly DEMO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."
    kubectl apply -f "$DEMO_DIR"/pebble/
    kubectl apply -f "$DEMO_DIR"/monitoring/
    kubectl apply -f "$DEMO_DIR"/jaeger/
    kubectl apply -f "$DEMO_DIR"/whoami/
    kubectl apply -f "$DEMO_DIR"/hotrod/

    echo "Demo cluster is ready."
    exit 0
}

check-tools() {
  cmdList="teectl kubectl k3d"
  for cmd in $cmdList; do
    echo -n "checking ${cmd}: "
    command -v "$cmd" >/dev/null 2>&1 || {
      echo "I require $cmd but it's not installed. Aborting,"
      exit 1
    }
  done
}

prepare-docker-images() {
    TRAEFIKEE_IMAGE="containous/traefikee:$(teectl version | grep Version | cut -f 2 -d ':' | tr -d "[:blank:]" || "")"

    docker pull containous/whoami:latest
    docker pull "$TRAEFIKEE_IMAGE"
    k3d import-images "${TRAEFIKEE_IMAGE}"
}

setup-traefikee() {
    teectl setup --force --kubernetes

    teectl setup gen --license="${TRAEFIKEE_LICENSE_KEY}" --controllers 1 --proxies 2 > /tmp/traefikee.yml

    kubectl apply -f /tmp/traefikee.yml
}

setup-k3s() {
  if errlog=$(mktemp) && k3d list 2> "$errlog" && ! test -s "$errlog"; then
    echo "Starting existing k3s cluster."
    k3d start
  else
    echo "Setting up k3s cluster."
    k3d create --workers=2 --publish="80:80" --publish="443:443" --publish="9000:9000" --server-arg --no-deploy --server-arg traefik
  fi

  #Wait until cluster is ready
  while test "$(k3d list | grep k3s-default | cut -f 4 -d '|' | tr -d "[:space:]")" != "running"
  do
    echo "Waiting for k3s cluster state: RUNNING."
    sleep 1
  done

  echo "Kubernetes cluster is ready."
}

main "$@"
