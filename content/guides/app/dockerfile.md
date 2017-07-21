+++
title = "Writing a Dockerfile"
weight = 2
+++

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