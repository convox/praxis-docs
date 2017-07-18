+++
title = "Convox 2.0 Documentation"
+++

Welcome to Convox. Convox is an application platform that unifies development, testing and deployment. 

## How It Works

Try the Convox workflow in minutes. Configure your first app, start a development environment, run the test suite, then run a continuous integration and deployment workflow.

1. Configure

    ```yaml
    services:
      web:
        certificate: ${HOST}
        port: 1313
        scale: 2
        test: make test
    ```

2. Develop locally

    ```bash
    $ convox start
    ```

3. Test locally

    ```bash
    $ convox test
    ```

4. Configure continuous integration

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

5. Configure continuous deployment

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


## Getting Started

