+++
title = "Resources"
alwaysopen = false
draft = true
weight = 2
+++

Resources are external services. The connection info is in a `RESOURCE_URL` environment variable that a client connects to. The most common resources are databases -- stateful services that you app will write and read data from.

convox.yml

```yaml
resources:
  database:
    type: postgres
services:
  web:
    resources:
      - database
```

```sh
$ cx resources
NAME      TYPE      ENDPOINT
database  postgres  postgres://postgres:password@database.resource.interface.convox:5432/app?sslmode=disable

$ cx run web env
DATABASE_URL=postgres://postgres:password@database.resource.interface.convox:5432/app?sslmode=disable

$ psql postgres://postgres:password@database.resource.interface.convox:5432/app?sslmode=disable
psql (9.6.2, server 9.5.6)
Type "help" for help.

app=# SELECT * FROM users;
```

## Resource Types

- [PostgreSQL](postgres)
- MySQL
- Redis
- RabbitMQ
