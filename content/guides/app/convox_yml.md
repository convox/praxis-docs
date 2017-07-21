+++
title = "Writing a convox.yml file"
weight = 1
+++

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
