+++
title = "PostgreSQL"
alwaysopen = true
+++

PostgreSQL is a SQL database server. To add Postgres to an app, define a resource and add it to one or more services in `convox.yml`:

```yaml
resources:
  database:
    type: postgres
services:
  web:
    resources:
      - database
  worker:
    resources:
      - database
```

Deploy the app. A Postgres database will be provisioned, and the web and worker process will be restarted with a `DATABASE_URL` environment variable with connection info for the resource.

## Providers

In production you should always use a managed Postgres service that takes care of database monitoring, failover and backups.

| Provider |  Implementation                                                     |
|----------|---------------------------------------------------------------------|
| Local    | [convox/postgres](https://github.com/convox/postgres) Docker image  |
| AWS      | [RDS for PostgreSQL](https://aws.amazon.com/rds/postgresql/)        |


{{% wip %}}
## Proxy

A Postgres database is configured to not accept connections from the internet for security purposes. The `cx resource proxy` command enables a Convox user to open up a secure tunnel to the database for temporary access:


```sh
$ cx resources proxy database
starting proxy to database: OK
listening at localhost:5432: OK
connect to: postgres://postgres:password@localhost:5432/app?sslmode=disable

$ psql postgres://postgres:password@localhost:1234/app?sslmode=disable
psql (9.6.2, server 9.5.6)
Type "help" for help.

app=# 
```
{{% /wip %}}

## Manual Dump and Restore

Add the Postgres client tools to your app. For a Debian Jessie based image, the Dockerfile recipe is:

```Dockerfile
ARG POSTGRES_CLIENT_VERSION=9.6
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add - \
  && echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" >> /etc/apt/sources.list.d/pgdg.list \
  && apt-get update \
  && apt-get install -y awscli postgresql-client-${POSTGRES_CLIENT_VERSION}
```

Now you can use `cx run` on a production app to call the `pg_dump` utility:

```bash
$ cx run web 'pg_dump $DATABASE_URL' --app myapp-production --rack myorg/production > production.dump
```

Then you can use `psql` on your development computer to load the database:

```sh
$ cx resources
NAME      TYPE      ENDPOINT
database  postgres  postgres://postgres:password@database.resource.interface.convox:5432/app?sslmode=disable

$ psql postgres://postgres:password@database.resource.interface.convox:5432/app?sslmode=disable < production.dump
SET
CREATE TABLE
COPY 130
CREATE INDEX
GRANT
```