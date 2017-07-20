+++
title = "Preparing an app"
weight = 2
+++

A Convox app requires configuration files that declare everything an app needs to run. A `convox.yml` file declares all the app services and backing-resources like databases. A `Dockerfile` declares the operating system (OS), OS dependencies, language and language dependencies.

With a good `convox.yml` and `Dockerfile` recipe, an app will work on any laptop and cloud environment.

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

## Writing and verifying a convox.yml file

It might take some work to write a config files for an existing app. The good news is the `cx test`, and `cx start` commands will verify our progress.

Let's get our first service up and running.

1. Define a service type and Docker image. A well-built image will describe everything the service needs to run such as the operating system, system dependencies and a default service command.

    ```yaml
    services:
      web:
        image: httpd
    ```

2. Run `cx test`. This quickly validates that the `convox.yml` structure and image is correct.

    ```
    $ cx test
    convox  | creating app test-1500563680: OK
    build   | pulling: httpd
    build   | running: docker tag httpd convox/test-1500563680/web:BWGISDSPJH
    build   | build complete
    release | starting: convox.test-1500563680.service.web.1
    ```

3. Run `cx start`. This allows you to interactively verify the app works. This reveals that our web service is starting but not yet available over HTTPS.

    ```
    $ cx start
    build   | pulling: httpd
    convox  | starting: convox.myapp.service.web.1
    web     | [Thu Jul 20 14:58:32.542983 2017] Command line: 'httpd -D FOREGROUND'

    $ cx services
    NAME  ENDPOINT
    web
    ```

4. Specify the port that the web server is listening on as defined in the Dockerfile. This tells Convox to configure the load balancer for the service. Run `cx start` and see that service is now available over HTTPS.

    ```yaml
    services:
      web:
        image: httpd
        port: 80
    ```

    ```
    $ cx start
    convox  | starting: convox.myapp.service.web.1
    web     | [Thu Jul 20 14:58:32.542983 2017] Command line: 'httpd -D FOREGROUND'

    $ cx services
    NAME  ENDPOINT
    web   https://web.myapp.convox

    $ curl https://web.myapp.convox
    <html>It works!</html>
    ```

## Customizing services

1. Define the environment variables a service expects. Variables can be required or optional with a default. This is a whitelist, anything not defined here will not be available to the service. 

    ```yaml
    services:
      web:
        environment:
          - GITHUB_KEY
          - GITHUB_SECRET
          - ROLLBAR_TOKEN=
          - ENV=development
        image: httpd
        port: 80
    ```

    ```
    $ cx start
    required env: GITHUB_KEY, GITHUB_SECRET

    $ cx env set GITHUB_KEY=2dd70d3... GITHUB_SECRET=7080a30e...
    updating environment: OK

    $ cx start
    convox  | starting: convox.myapp.service.web.1
    ```

2. Define the scale for a service. This defines how many service processes to run at minimum and how much memory they require.

    ```yaml
    services:
      web:
        image: httpd
        port: 80
        scale:
          count: 2
          memory: 1024
    ```

    ```
    $ cx start
    convox  | starting: convox.myapp.service.web.1
    convox  | starting: convox.myapp.service.web.2
    web     | [Thu Jul 20 16:00:40.001509 2017] Command line: 'httpd -D FOREGROUND'
    web     | [Thu Jul 20 16:00:41.269432 2017] Command line: 'httpd -D FOREGROUND'
    ```

3. Override the command. The Dockerfile specifies a default "CMD". This can be overridden 

    ```yaml
    services:
      web:
        command: httpd -f custom.conf
        image: httpd
        port: 80
    ```

4. Define a custom test command. Here we add a "script" that verifies config files and performs an integration test around the service.

    ```yaml
    services:
      web:
        image: httpd
        port: 80
        test: httpd -C "ServerName test" -t && apt-get update && apt-get install -y curl && curl -k https://web.$APP.convox/ | grep "It works"
    ```

    ```bash
    $ cx test
    convox  | creating app test-1500563680: OK
    build   | pulling: httpd
    build   | running: docker tag httpd convox/test-1500563680/web:BWGISDSPJH
    build   | build complete
    release | starting: convox.test-1500572611.service.web.1
    web     | running: httpd -C "ServerName test" -t
    web     | Syntax OK
    web     | <html><body><h1>It works!</h1></body></html>

    $ echo $?
    0
    ```


4. Customize health checks. An HTTP service must pass a health check or a deploy will not succeed.

    ```yaml
    services:
      web:
        health: /server-status
        image: httpd
        port: 80
    ```

## Writing and verifying a Dockerfile

So far we have used an existing Docker image. For a real app we will need to write our own Dockerfile with commands that copy our app code and install and use custom build tools.

Let's make our first custom Dockerfile.

1. Change the service to build an image from a custom Dockerfile. Create a Dockerfile that references the base image.

    ```yaml
    services:
      web:
        build: .
        port: 80
    ```

    ```Dockerfile
    FROM httpd

    COPY . .
    ```

2. Run `cx test`. This quickly validates we are building a custom image correctly.

    ```bash
    $ cx test
    convox  | creating app test-1500571270: OK
    build   | building: .
    build   | Step 1/1 : FROM httpd
    build   | Successfully built e0ceae115daa
    build   | running: docker tag 9836064b9412 convox/test-1500571194/web:BFJUVHSKGG
    build   | build complete
    release | starting: convox.test-1500571270.service.web.1
    ```

3. 


#### Define Resources

Differences between services: commands, test commands, 

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