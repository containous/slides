# HTTP Router with a WWR Load Balancer

* Start the stack:

```shell
docker-compose up -d
```


*  Check the load balancing

```bash
curl http://canary.docker.localhost
```

Send the request at least 3 times and check that we have 3 whoami response then 1 nginx response.

* Cleanup:

```shell
docker-compose down -v
```
