+++
title = "Cloud Deployment"
weight = 2
+++


Convox is a universal application framework. When you deploy applications using the Convox CLI, API and SDK you completely abstract away concerns about where your application is running. In minutes you can set up a production environment that leverages reliable cloud services to run your app.

This document will walk you through creating a Convox account and setting up an AWS-based production environment for an app.

If you are new to Convox, we encourage you to first [sign up for Convox](https://ui.convox.com/auth/new) and read the [local development walk through](/walkthroughs/local/) to explore how Convox turns your development computer into a application platform.

## Setting up your organization

### Sign up for Convox

Visit the [Convox signup page](https://ui.convox.com/auth/new). Here you can sign up with an email and set a password, or sign up through GitHub or Google.

### Create an organization

Next, create an organization. 

We'll call the org "ingen", the name of our exciting biotech startup.

All of your Convox resources -- integrations, Racks and apps -- will belong to this org. Access to these resources will be shared with other org members.

### Manage team members

Optionally, you can now visit the [org page](https://ui.convox.com/org) to set up team members. Since you created the org, you have been given an *admin role*.

Click "Add Another User", and enter the email address of your colleague.

If you want them to help manage integrations, create Racks, and invite other team members, also grant them the "admin" role. If you want to restrict them to just managing apps, grant them the "dev" role.

## Setting up your production environment

### Setting up your AWS integration

Next, visit the [integrations page](https://ui.convox.com/integrations). This is the hub that connects your organization to other service providers like AWS for infrastructure and GitHub for source control.

Click the [Enable AWS](https://ui.convox.com/integrations/aws/new) button.

We'll name the AWS integration "production" because it will connect to our primary AWS account and eventualy host our production Rack and apps.

Next, supply administrator access keys. Convox will use these keys once to set up the integration, then discard them.

Create a new "IAM user with programmatic access" to generate new keys. Follow the [Creating an IAM Users](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html#id_users_create_console) guide to generate these.

1. Sign into the [AWS IAM console](https://console.aws.amazon.com/iam/home#/users)
2. In the "User name" field enter "convox-temp"
3. In the "Access type" field, select "Programmatic access"
4. Click "Next: Permissions"
5. Select the "Attach existing policies directly" option, then check the "AdministratorAccess" policy
6. Click "Next: Review" then "Create User"
7. Click "Download .csv"

Now you can drag the "credentials.csv" file onto the [New AWS Integration](https://ui.convox.com/integrations/aws/new) form.

Then click "Enable". You'll see a confirmation message like "AWS integration enabled for account 922560784203". Convox is now integrated with your AWS account and can set up Racks.

Finally you can delete the "convox-temp" IAM user.

### Install the production environment

Next visit the [new Rack page](https://ui.convox.com/racks/new). Here you can install Rack in your AWS account.

You can use the default settings here. Call the Rack "production" because it will host our production apps. Use the standard "us-east-1" region. Use the "production" AWS integration that you just set up.

Click "Install". You'll see a confirmation message the the "Rack is installing". In a few minutes you will see a status of "installed", and your production environment will be up and running.

### Connect the CLI to the production environment

First, install the Convox `cx` command line client.

#### MacOS

```console
$ curl https://s3.amazonaws.com/praxis-releases/cli/darwin/cx -o /usr/local/bin/cx
$ chmod +x /usr/local/bin/cx
```

#### Linux

```console
$ curl https://s3.amazonaws.com/praxis-releases/cli/linux/cx -o /usr/local/bin/cx
$ chmod +x /usr/local/bin/cx
```

Now connect the `cx` command to your Convox account.

```console
$ cx login
Email: john@ingen.com
Password: *****
Authenticating with ui.convox.com: OK
```

If you signed up with GitHub or Google, visit the [edit user](https://ui.convox.com/user/edit) page to set your account password first.

Then you can list your Racks and switch to your production Rack:

```console
$ cx racks
RACKS
ingen/production
local

$ cx switch ingen/production
OK
```

## Deploying your first app

### Clone the example app

We'll use the Convox documentation site to demonstrate deployment. It's a Go app using the Hugo project for static websites.

If you don't already have it from the [development walkthrough](/walkthroughs/local/), clone the app and enter its directory:

```console
$ git clone https://github.com/convox/docs.git
$ cd docs/
```

#### convox.yml

The first thing to take note of in the project is the `convox.yml` file. This is where the app's description and configuration live.

```yaml
services:
web:
    certificate: ${HOST}
    environment:
    - HOST=web.docs.convox
    - HUGO_TITLE="Convox 2.0 Documentation"
    port: 1313
    scale: 2
    test: bin/test
```

The `convox.yml` for this app is straightfoward. It defines a single service called `web` with an SSL certificate that will be automatically configured for the domain specified by the app's `HOST` environment variable. `HOST` is automatically set and can be overridden for a custom domain.

Two copies of the container will be run, according to the `scale` setting.

### Deploy the app

Now you can deploy the app to your production Rack.

First you'll need to create an app to use as a deployment target:

```console
$ cx apps create docs
```

You should now see it in your apps list:

```console
$ cx apps
NAME  STATUS
docs  running
```

Now deploy:

```console
$ cx deploy
building: /Users/matthew/code/convox/docs
uploading: OK
starting build: bc5f7812
running: docker build -t 9836064b /tmp/503720936
Step 1/8 : FROM golang:1.8.3
Step 2/8 : RUN apt-get update && apt-get install -y curl python-pip
Step 3/8 : RUN pip install pygments
Step 4/8 : RUN go get -v github.com/gohugoio/hugo
Step 5/8 : WORKDIR /app
Step 6/8 : COPY . .
running: docker tag production-docs/web:BWWPTMIDWL 665986001363.dkr.ecr.us-east-1.amazonaws.com/produ-repos-2axsg073lrv8:web.BWWPTMIDWL
pushing: 665986001363.dkr.ecr.us-east-1.amazonaws.com/produ-repos-2axsg073lrv8:web.BWWPTMIDWL
build complete
UPDATE_IN_PROGRESS    production-docs          AWS::CloudFormation::Stack
CREATE_COMPLETE       ServiceWebTargetGroup    AWS::ElasticLoadBalancingV2::TargetGroup
CREATE_COMPLETE       ServiceWebListenerRule   AWS::ElasticLoadBalancingV2::ListenerRule
CREATE_COMPLETE       ServiceWebTasks          AWS::ECS::TaskDefinition
CREATE_COMPLETE       ServiceWeb               AWS::ECS::Service
UPDATE_COMPLETE       production-docs          AWS::CloudFormation::Stack
release promoted: RNPMYNUTQO
```

The application is now deployed to the production Rack. You can find its endpoints with the CLI:

```console
$ cx services
NAME  ENDPOINT
web   https://docs-web.produ-balan-yqveh744gpex-2137821817.us-east-1.rack.convox.io/
```

You can visit the service endpoint to view it.

With a Convox Organization, an AWS integration, the `convox.yml` file and a `cx deploy` command, you have:

* A production-ready private cloud
* A static, online hostname
* Trusted SSL
* Load balancing to two containers

### Look at the logs

The app is running in the cloud. You can verify this by looking at its logs:

```console
$ cx logs
2017-07-24 19:23:06 convox/release/ROQQTYAECB UPDATE_IN_PROGRESS    production-docs   AWS::CloudFormation::Stack
2017-07-24 19:23:14 convox/release/ROQQTYAECB UPDATE_COMPLETE       ServiceWebTasks   AWS::ECS::TaskDefinition
2017-07-24 19:23:17 convox/release/ROQQTYAECB UPDATE_IN_PROGRESS    ServiceWeb        AWS::ECS::Service
2017-07-24 19:24:27 docs-staging/web/226b9d67e1e2 Started building sites ...
2017-07-24 19:24:29 docs-staging/web/226b9d67e1e2 Web Server is available
2017-07-24 19:25:10 docs-staging/web/815dfa714ed2 Started building sites ...
2017-07-24 19:25:10 docs-staging/web/815dfa714ed2 Web Server is available
2017-07-24 19:25:19 convox/release/ROQQTYAECB UPDATE_COMPLETE       ServiceWeb        AWS::ECS::Service
2017-07-24 19:25:26 convox/release/ROQQTYAECB UPDATE_COMPLETE       production-docs   AWS::CloudFormation::Stack
2017-07-24 19:25:26 convox/release/ROQQTYAECB release promoted: ROQQTYAECB
```

Notice that you see logs for the two processes requested in the convox.yml `scale` config, rolling out between the AWS events.

### Update the app

Now that you have the app up and running, you can try the deployment cycle by making a change to the source code and deploying it to your production Rack.

Open `content/_index.md` in the project and add the text "Hello, this is a production change!" right below the Introduction header. After the edit your file should look like this:

```markdown
+++
title = "Convox 2.0 Documentation"
class = "home"
+++

# Welcome

Hello, this is a change!
```

Then deploy the changes:

```console
$ cx deploy
```

Reload the site in your browser and verify that the welcome text has changed.

### Run tests

You can test an app using `cx test`. This command will create a temporary app, deploy the current code to it, and sequentially run the `test:` command specified for each service. If a `test:` command is not specified, no tests will be run. `cx test` will abort and pass through any non-zero exit code returned by a test command.

```console
$ cx test
convox  | creating app test-1498754013: OK
build   | building: /Users/matthew/code/convox/docs
build   | uploading: OK
build   | starting build: d62123b8
build   | running: docker build -t 9836064b /tmp/144541219
...
build   | build complete
release | UPDATE_IN_PROGRESS    staging-test-1500935421       AWS::CloudFormation::Stack
...
release | UPDATE_COMPLETE       staging-test-1500935421       AWS::CloudFormation::Stack
web     | running: bin/test
web     | ✅  build returned 0
web     | ✅  /index.htm returned 404 response
web     | ✅  / returned expected content
web     | ✅  /index.json returned expected content
```

You may notice that running tests took seconds in on a local Rack but takes minutes on an AWS Rack. The advantage of running tests on AWS is that these tests use the same exact environment -- image repository, load balancer and container scheduler -- as your production apps. If `cx test` passes on an AWS Rack, you can feel very confident that the next production AWS deploy will work.

### Preparing releases

In production it is common to create a release and run some commands against it before rolling out the entire change to production. This is particularly useful to run pre-deploy commands like database migrations or asset uploads.

The build, configure and promote steps are possible with the CLI so you can customize your workflow.

First make another change. Open `content/_index.md` and replace the "Hello, this is a change!" text with "Hey, this is another change.".

Next, create a build but not deploy it:

```console
$ cx build
building: /Users/matthew/code/convox/docs
uploading: OK
starting build: bc5f7812
running: docker build -t 9836064b /tmp/503720936
Step 1/8 : FROM golang:1.8.3
...
build complete
```

Then, set a new environment variable:

```console
$ cx env set HOST=docs.ingen.com
updating environment: OK
```

Next look at the release log:

```console
$ cx releases
ID          BUILD       STATUS    CREATED
ROQQTYAECB  BJUECRBJUO  created   5 minutes ago
RXZMQKQGDO  BJUECRBJUO  created   7 minutes ago
RSERYSNXSD  BSVZFICDSL  promoted  11 minutes ago
```

Finally, run a command against the newly created release:

```console
$ cx run --release ROQQTYAECB web bash
root@c47045c1952f:/app#
```

In this interactive shell you can double check the latest code and environment and run commands safely.

When you're confident that the release is ready for production, promote it:

```console
$ cx promote
```

## Conclusion

Convox makes managing apps in the cloud easier than ever. With a good `convox.yml` recipe, `cx deploy` creates a production-ready cloud system with a single command.

The `build`, `env`, `run` `promote` and `deploy` commands turn AWS into a simple application platform. It's easy to manage many apps in the cloud which makes managing testing, staging and production environments simple.

Next, check out the [preparing app guide](/guides/app/) to learn how to write a good `convox.yml` recipe and deploy your own apps to the cloud.
