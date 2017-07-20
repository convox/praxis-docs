+++
title = "Tutorials"
alwaysopen = true
weight = 1
+++

It's your first day on the new job. The task before you is to familiarize yourself with the team's tools, so you can help develop, test and deploy the web app.

On past teams this was a huge challenge. The project docs and wiki were out of date, setting up a new laptop with Homebrew was a moving target, and good testing, sandbox and staging environments didn't exist.

It took weeks of guessing and asking for help from the team before the tools began making sense.

Thankfully this team uses Convox.

Convox turns your laptop into a powerful app development platform. The `cx` command line tool offers a simple workflow for managing apps on local machine.

On your laptop a single `cx start` command starts an interactive development environment. A single `cx test` command runs the entire test suite.

When working on microservices you can `cx deploy` the "api" app to run it in the background on your laptop, then `cx start` the "dashboard" app in the foreground to work on it. 

Every service is available through static, SSL-enabled hostnames like `https://web.api.convox` and `https://static.dashboard.convox`. Every database is available with connection strings like `postgres://database.resource.api.convox:5432` and a `DATABASE_URL` environment variable is automatically set in every process. 

Building, testing and using apps, and connecting together they components on your laptop has never been easier.

But wait, there's more...

Run the `cx switch` command to point the CLI to a cloud sandbox, staging or production environment. Now the same code, configuration and commands you use for development are managing systems in the cloud.

Your first staging deploy is a simple procedure that you've already tested on your laptop:

```
$ cx switch myorg/staging
$ cx build
$ cx run rake db:migrate
$ cx promote
```

---

These tutorials are for a developer just getting started with Convox, and walk through the Convox workflow on a sample application.

The first guide works with the app on your development machine that is running Docker. Some developers may stop here and just use Convox to manage apps in development.

The second guide works with the app in the Amazon Web Services (AWS) cloud. Some developers may appreciate the "dev/prod" parity of the platform and how Convox eliminates the complexities of AWS.

Let's get started with the [local development tutorial](/tutorials/local).