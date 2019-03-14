#!/bin/bash

> ./acme.json

docker stack deploy -c pebble.yml traefik
docker stack deploy -c traefik.yml traefik
docker stack deploy -c who.yml traefik