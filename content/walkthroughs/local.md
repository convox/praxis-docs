+++
title = "Local Development"
weight = 1
+++

Convox is a universal application framework. When you develop applications using the Convox CLI, API and SDK you completely abstract away concerns about where your application is running. In minutes you can set up a development environment that perfectly mimics how your app will run in production.

This document will walk you through installing the Convox CLI and setting up a Docker-based development environment for an app.

## Setting up your development environment

### Install the CLI

First, install the Convox `cx` command line client.

#### MacOS

    $ curl https://s3.amazonaws.com/praxis-releases/cli/darwin/cx -o /usr/local/bin/cx
    $ chmod +x /usr/local/bin/cx

#### Linux

    $ curl https://s3.amazonaws.com/praxis-releases/cli/linux/cx -o /usr/local/bin/cx
    $ chmod +x /usr/local/bin/cx

Confirm that cx is correctly installed and up to date:

    $ cx update
    updating cli to 20170628170448: OK

### Install the development environment

Your applications will run in an isolated environment called a *Rack*. While your *production Rack* will run on a cloud infrastructure provider like AWS, you can install a *local Rack* on your development computer. This makes it easy to achieve dev/prod parity.

To install a local Rack you'll first need to install Docker. The free Docker Community Edition can be found for your OS [here](https://www.docker.com/community-edition).

Once you have Docker up and running you can use `cx` to install a local Rack:

    $ sudo cx rack install local
    pulling: convox/praxis:20170720082526
    installing: /Library/LaunchDaemons/convox.rack.plist
    installing: /Library/LaunchDaemons/convox.router.plist

This starts the Convox API on your computer, which the `cx` tool interacts with to manage apps.

This also starts a "router" on your computer, which manages load balancing, DNS, and SSL certificates for your development apps. You can load the Convox Certificate Authority (CA) public key into your keychain so all development SSL traffic is trusted:

    $ open /Users/Shared/convox/ca.crt

In the "Add Certificates" dialog, select the "System" keychain, and click "Add". Then in the "Keychain Access" app, search for "convox" and double click on "ca.convox". In the root certificate dialog, change "When using this certificate:" to "Always Trust" and close the dialog.

![OS X Keychain Access](/images/keychain.png "OS X Keychain Access")

## Developing your first app

### Clone the example app

We'll use the Convox documentation site to demonstrate development. It's a Go app using the Hugo project for static websites.

Clone the app and enter its directory:

    $ git clone https://github.com/convox/docs.git
    $ cd docs/

#### convox.yml

The first thing to take note of in the project is the `convox.yml` file. This is where the app's description and configuration live.

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

The `convox.yml` for this app is straightfoward. It defines a single service called `web`.

Nested under `web` is a `certificate` config. An SSL certificate will be automatically configured for the domain specified by the app's `HOST` environment variable. `HOST` is automatically set and can be overridden for a custom domain.

The `port` configuration means processes for the web service will listen on port 1313 for http requests.

Two copies of the container will be run, according to the `scale` setting.

The app's default test command is `bin/test` as configured by `test`. This will be used later in the tutorial.

The `convox.yml` you cloned also has a `workflows` section. You can ignore that for the purposes of this tutorial.

### Deploy the app

Now that you've seen what a Convox app looks like, you can deploy it to your local Rack.

First you'll need to create an app in your Rack to use as a deployment target:

    $ cx apps create docs

You should now see it in your apps list:

    $ cx apps
    NAME  STATUS
    docs  running

Now deploy:

    $ cx deploy
    building: /Users/matthew/code/convox/docs
    uploading: OK
    starting build: eed730a1
    running: docker build -t 9836064b /tmp/503720936
    Step 1/8 : FROM golang:1.8.3
    Step 2/8 : RUN apt-get update && apt-get install -y curl python-pip
    Step 3/8 : RUN pip install pygments
    Step 4/8 : RUN go get -v github.com/gohugoio/hugo
    Step 5/8 : WORKDIR /app
    Step 6/8 : COPY . .
    running: docker tag 9836064b convox/docs/web:BMMSMIPUYU
    build complete
    starting: convox.docs.service.web.1
    starting: convox.docs.service.web.2

The application is now deployed to your local Rack. You can find its endpoints with the CLI:

    $ cx services
    NAME  ENDPOINT
    web   https://web.docs.convox

You can visit [https://web.docs.convox](https://web.docs.convox) to view it. If you get an SSL warning, review the certificate authority setup in the [installation instructions](#install-the-development-environment).

With the `convox.yml` file and a `cx deploy` command you have an app running with:

* A static hostname
* Trusted SSL
* Load balancing to two containers

### Look at the logs

The app is running in the background of your laptop. You can verify this by looking at its logs:

    $ cx logs
    2017-07-24 22:11:16 docs/web/d2e726148ecd Started building sites ...
    2017-07-24 22:11:16 docs/web/d2e726148ecd 44 regular pages created
    2017-07-24 22:11:16 docs/web/d2e726148ecd Watching for changes in /app/{data,content,layouts,static,themes}
    2017-07-24 22:11:16 docs/web/d2e726148ecd Web Server is available at //web.docs.convox/ (bind address 0.0.0.0)
    2017-07-24 22:11:16 docs/web/7f44516edc87 Started building sites ...
    2017-07-24 22:11:16 docs/web/7f44516edc87 44 regular pages created
    2017-07-24 22:11:16 docs/web/7f44516edc87 Watching for changes in /app/{data,content,layouts,static,themes}
    2017-07-24 22:11:16 docs/web/7f44516edc87 Web Server is available at //web.docs.convox/ (bind address 0.0.0.0)

Notice that you see logs for the two processes requested in the convox.yml `scale` config.

### Edit the source

Now that you have the app up and running, you can try the development cycle by making a change to the source code and deploying it to your local Rack.

Open `content/_index.md` in the project and add the text "Hello, this is a change!" right below the Introduction header. After the edit your file should look like this:

    +++
    title = "Convox 2.0 Documentation"
    class = "home"
    +++
    
    # Welcome
    
    Hello, this is a change!

Then deploy the changes:

    $ cx deploy

Reload the site in your browser and verify that the welcome text has changed.

### Run tests

You can test an app using `cx test`. This command will create a temporary app, deploy the current code to it, and sequentially run the `test:` command specified for each service. If a `test:` command is not specified, no tests will be run. `cx test` will abort and pass through any non-zero exit code returned by a test command.

    $ cx test
    convox  | creating app test-1498754013: OK
    build   | building: /Users/matthew/code/convox/docs
    build   | uploading: OK
    build   | starting build: d62123b8
    build   | running: docker build -t 9836064b /tmp/144541219
    ...
    build   | build complete
    release | starting: convox.test-1498754013.service.web.1
    release | starting: convox.test-1498754013.service.web.2
    web     | running: bin/test
    web     | ✅  build returned 0
    web     | ✅  /index.htm returned 404 response
    web     | ✅  / returned expected content
    web     | ✅  /index.json returned expected content

If you'd like to see the test fail, open `config.toml` and delete the `theme = "docdock"` line and run `cx test` again.

With the `convox.yml` file and a `cx test` command you have achieved development / test environment parity.

### Building without deploying

While `cx deploy` is an easy way to deploy changes, the build, configure and promote steps are possible with the CLI so you can customize your workflow.

First make another change. Open `content/_index.md` and replace the "Hello, this is a change!" text with "Hey, this is another change.".

Next, create a build but not deploy it:

    $ cx build
    uploading: .
    starting build: 16dd308f
    running: docker build -t 9836064b /tmp/124604449
    Sending build context to Docker daemon 19.56 MB
    Step 1/8 : FROM golang:1.8.3
    Step 2/8 : RUN apt-get update && apt-get install -y curl python-pip
    ...
    Successfully built 5c9e32a1e857
    running: docker tag 9836064b convox/docs/web:BHRATEYFZS

Building without deploying is useful to stage changes and then deploy them as a unit.

### Set an environment variable

A new release is also created when you change the application's environment.

    $ cx env set FOO=bar
    updating environment: OK

### View releases

Every time you build your app or change an environment variable, a new "release" is created to keep up with these changes. You can list these releases:

    $ cx releases
    ID          BUILD       STATUS    CREATED
    RGCMQGSYYN  BLFBFMFXFR  created   4 seconds ago
    RTTOIDQIFF  BLFBFMFXFR  created   2 minutes ago
    RTKJFWMKYG  BHRATEYFZS  active    4 minutes ago
    RYCQLGAAAV  BJKETOESCA  promoted  19 minutes ago

You can see from this list that the most recent release, `RGCMQGSYYN`, was created but not promoted which means its changes have not yet been deployed.

Releases that aren't promoted are useful to run pre-deploy commands like database migrations or asset uploads.

    $ cx run --release RGCMQGSYYN web hugo convert toJSON -o /tmp

### Diff releases

Before you promote a release, you can use `cx diff` to summarize the changes about to be deployed:

    $ cx diff
    fetching RWSHXASNDF: OK
    fetching RTKJFWMKYG: OK
    diff --git 663957140/.env 924574153/.env
    index e69de29..1566bb1 100644
    --- 663957140/.env
    +++ 924574153/.env
    @@ -0,0 +1 @@
    +FOO=bar

    diff --git 663957140/content/index.md 924574153/content/index.md
    index 308583e..82f79db 100644
    --- 663957140/content/index.md
    +++ 924574153/content/index.md
    @@ -5,7 +5,7 @@ weight: 5
    
    # Introduction
    
    -Hello, this is a change!
    +Hey, this is another change.

Once you verify the diff you can promote it.

### Promote a release

    $ cx promote
    promoting RWSHXASNDF: OK
    starting: convox.docs.service.web.1
    starting: convox.docs.service.web.2

The release will now show as active.

    $ cx releases
    ID          BUILD       STATUS    CREATED
    RWSHXASNDF  BOMBKQZCLA  active    4 minutes ago
    RGCMQGSYYN  BLFBFMFXFR  created   5 minutes ago
    RTTOIDQIFF  BLFBFMFXFR  created   7 minutes ago
    RTKJFWMKYG  BHRATEYFZS  promoted  11 minutes ago
    RYCQLGAAAV  BJKETOESCA  promoted  27 minutes ago

Refresh your browser to see your change in action!

### A faster development loop

You may be thinking that this is shaping up to be a pretty nice workflow but it's a bit laborious for development. You can use `cx start` to pull an application into the foreground. `cx start` will restart the services of the application in development mode and set up live code-sync with your local development checkout allowing you to use your own tools and editor.

    $ cx start

Go ahead and delete the "Hello, this is a change!" line you added previously. You'll be able to immediately view the changes in your browser.

#### Code sync

Convox code sync allows changes you make in your local files to be instantly reflected in the app containers. This lets you see the effect of changes without having to redeploy your appliction repeatedly.

Any directory that appears in a `COPY` or `ADD` line in your Dockerfile will be synced. This project has:

    COPY . .

in the Dockerfile, so the entire project directory is synced.

## Conclusion

Convox makes developing apps on your laptop easier than ever. With a good `convox.yml` recipe, `cx start` and `cx test` boot an interactive development and test environment respectively with a single command.

The `build`, `env`, `diff`, `run` and `deploy` commands turn your laptop into a local application platform. It's now possible to configure and manage more than one development app, which makes working on microservices a breeze.

Next, check out the [cloud walkthrough](/walkthroughs/cloud/) to see how the Convox makes managing your production environment just as easy through the same exact commands and concepts.
