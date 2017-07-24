+++
title = "Convox 2.0 Documentation"
class = "home"
+++

## Welcome

Welcome to Convox, an application platform that offers perfect parity between development, testing and production environments.

Convox helps you build and deploy apps in minutes. It all starts with a `convox.yml`, a simple configuration file that describes everything about your app. This file is the blueprint for your app architecture.

From this Convox can start a development environment, run a test suite, and configure a reliable, scalable and cost-effective cloud architecture.

With Convox, when an app works on your laptop, you can be confident it will also work in production.

{{% tabs %}}
1. Configure
2. Develop
3. Test
4. Deploy
5. Automate
{{% /tabs %}}

{{% tab-contents %}}
1. The `convox.yml` file describes an app and its components like SSL certificate and process type and count. The `Dockerfile` describes app system dependencies.

    ```yaml
    services:
      web:
        certificate: ${HOST}
        environment:
          - HOST=web.docs.convox
        port: 1313
        scale: 2
        test: bin/test
    ```

    ```Dockerfile
    FROM golang:1.8.3

    RUN apt-get update && apt-get install -y curl python-pip
    RUN pip install pygments

    RUN go get -v github.com/gohugoio/hugo

    COPY . .

    CMD hugo server --baseURL=${HOST} -w
    ```

2. The `cx start` command launches an app on your laptop, with a load balancer and SSL just like production.

    ```bash
    $ cx start
    build   | building: docs
    build   | Step 1/6 : FROM golang:1.8.3
    build   | Step 2/6 : RUN apt-get update && apt-get install -y curl python-pip
    build   | Step 3/6 : RUN pip install pygments
    build   | Step 4/6 : RUN go get -v github.com/gohugoio/hugo
    build   | Step 5/6 : WORKDIR /app
    build   | Step 6/6 : COPY . .
    build   | running: docker tag 9836064b convox/docs/web:BFGEZTOEXR
    build   | build complete
    convox  | promoting RIJBGELKDA
    convox  | starting: convox.docs.service.web.1
    convox  | starting: convox.docs.service.web.2
    web     | syncing: . to /app
    web     | Listening on port 1313

    $ cx services
    NAME  ENDPOINT
    web   https://web.docs.convox
    ```

    ![Secure Static Hostname](/images/chrome-secure.png "Secure Static Hostname")


3. The `cx test` command runs an app test suite on your laptop.

    ```bash
    $ cx test
    build   | building: docs
    convox  | promoting RZUGPIDSHG
    convox  | starting: convox.test-1498754013.service.web.1
    convox  | starting: convox.test-1498754013.service.web.2
    web     | running: bin/test
    web     | ✅  build returned 0
    web     | ✅  /index.htm returned 404 response
    web     | ✅  /index.html returned redirect response
    web     | ✅  / returned expected content
    web     | ✅  /index.json returned expected content
    ```

4. The `cx deploy` command launches an app in the cloud, where the VPC, load balancer and container schedule are a solved problem.

    ```bash
    $ cx switch myorg/production

    $ cx deploy
    building: myapp
    pushing: 665986001363.dkr.ecr.us-east-1.amazonaws.com/myapp:web.BWWPTMIDWL
    UPDATE_IN_PROGRESS    production-myapp          AWS::CloudFormation::Stack
    CREATE_COMPLETE       ServiceWebTargetGroup     AWS::ElasticLoadBalancingV2::TargetGroup
    CREATE_COMPLETE       ServiceWebListenerRule    AWS::ElasticLoadBalancingV2::ListenerRule
    CREATE_COMPLETE       ServiceWebTasks           AWS::ECS::TaskDefinition
    CREATE_COMPLETE       ServiceWeb                AWS::ECS::Service
    UPDATE_COMPLETE       production-myapp          AWS::CloudFormation::Stack
    release promoted: RNPMYNUTQO

    $ convox services
    NAME  ENDPOINT
    web   https://myapp-web.balancer-2137821817.us-east-1.rack.convox.io/
    ```

5. Workflows define how an app automatically move from development to production with continuous integration.

    ```yaml
    workflows:
        change:
          create:
            - test: staging
          update:
            - test: staging
        merge:
          master:
            - test: staging
            - deploy: staging/docs-staging
            - copy: production/docs-production
    ```

    ![GitHub Commit and Deploy Status](/images/github-status.png "GitHub Commit and Deploy Status")
{{% /tab-contents %}}

## Dev / Prod Parity

The `convox.yml` file unlocks agility in building and deploying apps. By describing all the architectural components your app needs, such as containers, databases, and queues, Convox can:

* Start everything your app needs on your laptop for development with a single command
* Set up and tear down test environments with no additional configuration
* Configure services to run your app in the cloud

## Learn More

If you're just getting started with Convox, you can follow a [walkthrough](/walkthroughs/) to develop and deploy an example app.

If you're migrating an app, check out the [guides](/guides/) for setting up your apps and the platform.

If you're writing a new app, check out the [app components reference](/reference/components/) to learn how a powerful and portable system architecture is only a few lines of code away.