# Basic Traefik Demo with HTTP and TCP

* Update your `/etc/hosts`:

```text
...
127.0.0.1   mongo1.localhost traefik.localhost webapp.localhost
```

* Start Traefik:

```shell
docker-compose up -d traefik
```

* Open the dashboard at <http://traefik.localhost>

* Start the HTTP webapp:

```shell
docker-compose up -d webapp
```

* Check the dashboard, and once you see the router, open the webapp at <http://webapp.localhost>

* Start MongoDB:

```shell
docker-compose up -d mongo
```

* Check the dashboard, and once you see the TCO router,
  then connect local `mongo` client to mongo's backend through Traefik:

```shell
mongo --host mongo1.localhost --port 27017
> show dbs
> exit
```

* Cleanup:

```shell
docker-compose down -v --remove-orphans
```
