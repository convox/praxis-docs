+++
title = "Convox 2.0 Documentation"
class = "home"
+++

Welcome to Convox, an application platform that unifies development, testing and deployment.

## How It Works

Convox helps you build and deploy an app in minutes. It all starts with a `convox.yml`, a simple configuration file that describes everything about your app. This file is your blueprint for starting a development environment, running a test suite, and deploying to a reliable, scalable and cost-effective cloud architecture.

{{% tabs %}}
1. Configure
2. Develop
3. Test
4. Deploy
5. Automate
{{% /tabs %}}

{{% tab-contents %}}
1. Configure

    ```yaml
    services:
      web:
        certificate: ${HOST}
        port: 1313
        scale: 2
        test: make test
    ```

2. Develop

    ```bash
    $ cx start
    build   | building: myapp
    build   | running: docker build -t 9836064b .
    build   | Step 1/2 : FROM debian/jessie:8
    build   | Step 2/2 : COPY . /app
    build   | Successfully built beafc72ce9f3
    build   | running: docker tag 9836064b convox/myapp/web:BNSEGLZHZM
    build   | build complete
    convox  | promoting RZUGPIDSHG
    convox  | starting: convox.myapp.service.web.1
    convox  | starting: convox.myapp.service.web.2
    web     | syncing: . to /app
    web     | Listening on port 1313

    $ cx services
    NAME  ENDPOINT
    web   https://web.praxis-site.convox

    $ open https://web.myapp.convox
    ```

3. Test

    ```bash
    $ cx test
    build   | building: myapp
    convox  | promoting RZUGPIDSHG
    convox  | starting: convox.test-1498754013.service.web.1
    convox  | starting: convox.test-1498754013.service.web.2
    web     | running: make test
    web     | ok  	github.com/myorg/myapp/api	0.024s
    web     | ok  	github.com/myorg/myapp/api/controllers	0.075s
    web     | ok  	github.com/myorg/myapp/client	0.014s
    web     | ok  	github.com/myorg/myapp/cmd/cli	0.040s

    $ echo $?
    0
    ```

4. Deploy

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

5. Automate

    ```yaml
    workflows:
        merge:
          master:
            - test: staging
            - deploy: staging/example-staging
            - copy: production/example-production
    ```

    ```bash
    $ git push github feature
    $ git pull-request -m 'new feature'
    $ git merge feature
    ```

    - ✅ convox/change — tests passed
    - 🚀 nzoschke deployed to staging/example-staging
    - 🚀 nzoschke started a deploy to production/example-production
{{% /tab-contents %}}

## Dev / Prod Parity

The `convox.yml` file unlocks agility in building and deploying apps. By describing all the architectural components your app needs, such as containers, databases, and queues, Convox can:

* Start everything your app needs on your laptop for development with a single command
* Set up and tear down test environments with no additional configuration
* Configure services to run your app in the cloud
