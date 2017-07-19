+++
title = "Convox 2.0 Documentation"
class = "home"
+++

Welcome to Convox. Convox is an application platform that unifies development, testing and deployment. 

## How It Works

Try the Convox workflow in minutes. Configure your first app, start a development environment, run the test suite, then run a continuous integration and deployment workflow.

{{% tabs %}}
1. Configure
2. Develop
3. Test
4. Continuous Integration
5. Continuous Deployment
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
    $ convox start
    ```

3. Test

    ```bash
    $ convox test
    ```

4. Continuous Integration

    ```yaml
    workflows:
      change:
        create:
          - test: staging
        update:
          - test: staging
    ```

    ```bash
    $ git push github feature
    $ git pull-request -m 'new feature'
    ```

    - ✅ convox/change — tests passed
    - ❌ convox/change — tests failed
    - ✅ convox/change — tests passed

5. Continuous Deployment

    ```yaml
    workflows:
        merge:
          master:
            - test: staging
            - deploy: staging/example-staging
            - copy: production/example-production
    ```

    ```bash
    $ git merge feature
    ```

    - ✅ convox/merge — tests passed
    - 🚀 nzoschke deployed to staging/example-staging
    - 🚀 nzoschke started a deploy to production/example-production
{{% /tab-contents %}}

## Dev / Prod Parity

Convox offers true parity between the development and production environments. The configuration file and commands used to manage an app in development work to manage an app in production.