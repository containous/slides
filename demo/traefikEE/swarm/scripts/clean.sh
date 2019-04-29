#!/bin/bash

export DOCKER_HOST=""

traefikeectl uninstall --clustername=swarm || true

sind delete --cluster=dockercon >/dev/null || true

docker ps | grep dockercon | awk '{print $1}' | xargs docker kill

docker system prune -f --volumes

rm -rf "${HOME}/.config/sind" "${HOME}/.config/traefikee/swarm.toml"

echo "== Cleaning complete"
exit 0
