# start keybase
# start docker

```sh
sind create --managers=3 --workers=3 -p 80:80 -p 443:443 -p 8080:8080

eval (sind env)

traefikeectl install \
    --licensekey=(cat /keybase/private/emilevauge/traefikee-license) \
    --dashboard \
    --swarm
```

# dashboard on http://localhost:8080

```sh
docker stack deploy -c demo/swarm/cheese.yaml cheese
```

# http://cheddar.docker.localhost
# http://stilton.docker.localhost
# http://wensleydale.docker.localhost

```sh
docker stack rm cheese
traefikeectl uninstall
sind delete
```