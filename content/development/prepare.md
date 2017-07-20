+++
title = "Preparing an App"
weight = 2
+++

A Convox app requires configuration files that declare everything an app needs to run. A `convox.yml` file declares all the app services and backing-resources like databases. A `Dockerfile` declares the operating system (OS), OS dependencies, language and language dependencies.

## convox.yml and Dockerfile

The `convox.yml` configuration file is central to the Convox platform. It is an complete declaration of all the components an app needs to run, such as:

* Service types (e.g. web and worker)
* Service commands
* Required and optional environment variables
* Health checks
* Backing resources (e.g. Postgres and Redis databases)

It also declares the app operating system by referencing a Docker Image or a Dockerfile recipe to build an image.

{{% tabs %}}
1. Static Site
2. Blog Engine
3. Web/Worker App
{{% /tabs %}}

{{% tab-contents %}}
1. An example [Hugo](https://gohugo.io/) static site with SSL

    ```yaml
    services:
      web:
        certificate: ${HOST}
        port: 80
        scale: 2
        test: make test
    ```

    ```Dockerfile
    FROM ubuntu:16.04

    RUN apt-get update && apt-get install -y curl python-pip
    RUN pip install pygments

    RUN curl -Ls https://github.com/spf13/hugo/releases/download/v0.20.7/hugo_0.20.7_Linux-64bit.deb -o /tmp/hugo.deb && \
        dpkg -i /tmp/hugo.deb && \
        rm /tmp/hugo.deb

    WORKDIR /app

    EXPOSE 1313

    CMD ["hugo", "server", "-w", "--bind", "0.0.0.0"]
    ```

2. An example [Wordpress](https://wordpress.org/) app with MySQL and a persistant volume. Uses the [official Docker wordpress image](https://hub.docker.com/_/wordpress/) so no Dockerfile necessary.

    ```yaml
    resources:
      database:
        type: mysql
    services:
      web:
        environment:
          - WORDPRESS_DB_HOST=database.resource.wordpress.convox:3306
          - WORDPRESS_DB_NAME=app
          - WORDPRESS_DB_PASSWORD=password
          - WORDPRESS_DB_USER=mysql
        health:
          interval: 5
          path: /
          timeout: 3
        image: wordpress:4.8.0-apache
        port:
          port: 80
          scheme: http
        resources:
          - database
        scale:
          count:
            min: 1
            max: 1
          memory: 256
        volumes:
          - /var/www/html
    ```

3. An example [Rails](https://rails.org) app with a web, worker, and queue.

    ```yaml
    resources:
      database:
        type: mysql
    services:
      web:
        environment:
          - WORDPRESS_DB_HOST=database.resource.wordpress.convox:3306
          - WORDPRESS_DB_NAME=app
          - WORDPRESS_DB_PASSWORD=password
          - WORDPRESS_DB_USER=mysql
        health:
          interval: 5
          path: /
          timeout: 3
        image: wordpress:4.8.0-apache
        port:
          port: 80
          scheme: http
        resources:
          - database
        scale:
          count:
            min: 1
            max: 1
          memory: 256
        volumes:
          - /var/www/html
    ```
{{% /tab-contents %}}

## Writing and verifying convox.yml file

It might take some work to write the config files for an existing app. The good news is the `cx build`, `cx start`, and `cx test` commands will help verify your progress. 

1. Define your service types, e.g. `web`, `worker`
2. Specify service Docker images or Dockerfiles
2. Define service commands like how to start the server and how to run tests
3. Define service environment, e.g. `GITHUB_API_TOKEN`. This is a whitelist, anything not defined here will not be available to your service.
4. Define HTTP/HTTPS service properties like the web server port, and health checks
5. Define app resources, e.g. Postgres and Redis, and what services use them

## Further reading:

* Convox.yml Reference
* Convox.yml vs Docker-Compose.yml
* [Best Practices for Writing Dockerfiles](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/)