+++
title = "Development"
alwaysopen = true
weight = 2
+++

A common DevOps problem:

> Operator: "We had to roll back the latest change, it took down the website...."
>
> Developer: "Strange, it works fine on my computer..."

Convox eliminates this class of problem entirely by offering strong **development and production parity** (dev/prod parity). The platform takes care to set up your laptop in a way that mimics exactly how an app will run in production.

Local apps are managed with the `cx` command line tool exactly how you expect on a cloud platform:

* Register a new app with `cx apps create`
* Run the newest version of the app with `cx deploy`
* Access the app at a static `https://web.myapp.convox` hostname

The `cx start` command wraps all this together into an interactive development environment, which starts the app with "code sync", ready for you to write new code.

This also makes working on microservices easier than ever. You can now deploy all of the microservice components into the development environment, then start the interactive environment on one or more of the components.

All of this is designed to provide strong guarantees around your code base. When apps run and pass tests on your laptop, it is certain that they will be easy and safe to deploy to the cloud.

## Next

These following docs, starting with [Installing the CLI](/development/cli/), walk through setting up the development environment for your apps.

## Further reading:

* [Development Environment Architecture](/advanced/dev_arch/)
* Production Environment Architecture
* Convox SDK
* [The Twelve-Factor App Dev/Prod Parity](https://12factor.net/dev-prod-parity)