+++
title = "Convox 2.0 Migration"
alwaysopen = true
weight = 1
+++

The Convox mission is clear:

You, an app developer, deserve to focus 100% on writing your business apps. Everything else is a distraction. 

The most common distractions are when you are responsible for all the other things you need to support your application code:

* Maintaining custom development scripts and docs
* Configuring and debugging test environments
* Designing, building and operating production infrastructure services

The Convox platform offers all this functionality so you don't have to build and manage internal devops tools yourself.

The result is that you focus on your app code, and we handle everything else to build, test and deploy it.

## Why Convox 2.0

The main reason devops tools are so distracting is because of the rapid rate of change in the space. What were best practices 6 months ago may no longer be, thanks to constant advances by Amazon, Docker, GitHub and other players in the ecosystem.

We took a hard look at how the Convox 1.0 platform was working and saw clear room for improvement.

### Moving from docker-compose.yml to convox.yml

We need a config file that declares everything a modern app needs to run.

The trusty `Procfile` format is way too simple, offering no hints about app environment, service protocols and health checks. 

The `docker-compose.yml` format offers ways to describe this. But the spec also includes literally 100s of options that Convox doesn't recommend or support like virtual networks. It also doesn't directly address important concepts like how you configure an HTTP vs TCP service and how you define periodic tasks.

The result hasn't been great. A config file might work one way in `docker-compose up`, another way in `convox start` and fail silently during a `convox deploy`.

So after careful consideration, we designed a new format, `convox.yml` with the goal of making it easy to configure a modern app. We hope that this format makes it easier than ever to describe the components of your app:

### Dev / prod parity

The [Twelve-Factor App methods](https://12factor.net/) show how differences between development and production, aka [dev/prod parity](https://12factor.net/dev-prod-parity), are a huge source of problems.

Convox 2.0 aims to solve this once and for all by making the local Docker-based environment work **exactly the same** as the AWS platform-as-a-service. We call this a "Local Rack".

Now the workflow is the same. You can `cx install` a Rack on your development computer and use `cx apps`, `cx env` and `cx deploy` to manage apps.

The application architecture is the same. Behind the scenes a local Rack has a load balancer which handles SSL and DNS to app containers. This gives you friendly, static hostnames like `https://web.docs.convox` for accessing the `web` service for the `docs` app and sets the proper forwarding headers.

The only difference is that the local Rack has a `cx start` command that adds live code syncing so you can make changes to an app in real-time with your text editor.

### Developing microservices

We know we are onto something with the Local Rack because it has fixed a common customer problem around developing microservices.

In Convox 1.0 you could only `convox start` one app at a time without dealing with port conflicts.

In Convox 2.0 you can deploy and run many apps to start them running in the "background" of your development computer. Then you can `cx start` one or more of these apps to bring the to the "foreground" for code syncing. 

Multiple apps can talk to each other with the friendly hostnames, e.g. the `https://web.dashboard.convox` service can talk to the `https://web.api.convox` service.

It's finally easy to work on microservices.

### Moving from ELB to ALB

On the production side, the problems with the AWS Elastic Load Balancer (ELB) have been clear for a while. The need for many ELBs has driven up monthly bills, and slowed down deployment times.

Convox 2.0 is ALB only and the results are glorious.

A Rack only needs a single ALB to run many apps, which brings the baseline price of an AWS Rack down to $30/month. ALB plays extremely nice with ECS and speeds up deployment times greatly.

Speed, reliability and cost are all better in Convox 2.0 thanks to ALB.

### Visibility

When things go wrong on Convox 1.0 it's common to open up the AWS Management Console to look at CloudFormation or ECS to find the problem. We consider the **ability** to do this a huge feature of Convox, but the **need** to do this a huge wart.

Convox 2.0 fixes this by baking AWS visibility into every command. Every `cx deploy` now shows every step of the AWS rollout and surfaces errors if they occur. It's now obvious when deployment errors happen, and more clear how to address them.

## How To Migrate

1. Download the 2.0 `cx` tool. It runs great along-side the 1.0 `convox` tool.
2. Install a Local Rack
3. Add a `convox.yml` file to your app and iterate on getting `cx start` and `cx test` 
4. Sign up for the 2.0 UI
5. Install and AWS Rack
6. Deploy 

## FAQ

### Is Convox 2.0 ready?

Yes. We have happy users of Local and AWS Rack and the platform is ready wider use.

While adopting any new production system can be scary, Convox still leverages AWS services -- specifically CloudFormation, ECS and ALB -- to offer an extremly reliable system.

### What does Convox 2.0 cost?

Convox is still open-source and free for single developers to use.

The smallest AWS Rack footprint is now $30/month and can run approximately 5 apps, depending on memory requirements.

A small team can use the web management console for $29/month. Larger teams start at $99/mo and $19/user.

Enterprise solutions for HIPAA and PCI and professional services are available, contact us to learn more.

### What is the 2.0 roadmap?

The short term roadmap includes launching these features:

* Continuous integration / continuous delivery workflows
* Service monitoring dashboard
* Internal service discovery

The medium term roadmap includes:

* Fine-grained access control 
* Audit logs

The long term vision also includes:

* An SDK for app components such as encryption keys and queues
* Another provider such as Google Cloud and/or Kubernetes

### How are you supporting 1.0 vs 2.0?

Convox 1.0 is largely in maintenance mode now, as a platform that has been working reliably for thousands of Racks and apps over the years. We still welcome contributions, but are only doing limited maintenance for security purposes and customizations for enterprise customers.

Convox 2.0 is in active development mode. We welcome your feedback and bug reports that will make the system better.

In general we only offer support for paying customers, and you can reach out to support@convox.com to discuss a support contract if you have questions.
