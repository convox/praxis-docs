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

```Docker
FROM httpd

COPY . .
```

2. Run `cx test`. This quickly validates we are building a custom image correctly.

```console
$ cx test
convox  | creating app test-1500571270: OK
build   | building: .
build   | Step 1/1 : FROM httpd
build   | Successfully built e0ceae115daa
build   | running: docker tag 9836064b9412 convox/test-1500571194/web:BFJUVHSKGG
build   | build complete
release | starting: convox.test-1500571270.service.web.1
```

3. Add system dependencies.

```Docker
FROM httpd

RUN apt-get update && apt-get install -y curl

COPY . .
```

4. Add default command. This is used if convox.yml does not define a `command:` for the service.

```Docker
FROM httpd

RUN apt-get update && apt-get install -y curl

COPY . .

CMD httpd -DFOREGROUND -f conf/httpd.conf
```

5. Add any production customizations like another command. Anything after a `## convox:production` line will run in a production `cx build` but not in a development `cx start`.

```Docker
FROM httpd

RUN apt-get update && apt-get install -y curl

COPY . .

CMD httpd -DFOREGROUND -f conf/httpd.conf

## convox:production
CMD httpd -DFOREGROUND -f production.conf
```
