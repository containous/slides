# start docker

docker run --name traefik \
    --publish 80:80 --publish 8080:8080 \
    --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
    --network traefik_net \
    traefik \
    --docker.swarmMode \
    --api
    
 docker stack deploy -c demo/docker/cheese.yaml cheese

 docker stack rm cheese