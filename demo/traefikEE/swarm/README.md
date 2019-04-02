# start keybase
# start docker

```sh
sind create --managers=3 --workers=3 -p 80:80 -p 443:443 -p 8080:8080 -p 55055:55055

eval (sind env)

traefikeectl install --debug \
    --licensekey=(cat /keybase/private/emilevauge/traefikee-license) \
    --dashboard \
    --swarm
```

# dashboard on http://localhost:8080

```sh
docker stack deploy -c demo/traefikEE/swarm/cheese.yaml cheese
```

# http://cheddar.docker.localhost
# http://stilton.docker.localhost
# http://wensleydale.docker.localhost

```sh
docker stack rm cheese
traefikeectl uninstall --debug
sind delete
```