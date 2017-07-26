+++
title = "AWS Install"
weight = 4
+++

An **AWS Rack** runs apps in the cloud. This makes it easy to build and run apps for staging and production.

## Pre-requisites

You need a Convox account to set up an AWS integration and install a Rack. Check out the [organizations guide](/guides/setup/orgs/) for instructions.

You will also need the `cx` tool on your computer to deploy apps to the Rack. Check out the [CLI guide](/guides/setup/cli/) for more details.

Finally, you will need an AWS account. A new account qualifies for the AWS free tier, which offers a great way to try Convox with little to no cost. Check out the [AWS Free Tier](https://aws.amazon.com/free/) for more details.

## Create an AWS Integration

Visit the [integrations page](https://ui.convox.com/integrations). This is the hub that connects your organization to other service providers like AWS for infrastructure and GitHub for source control.

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

### Install a Rack

Next visit the [new Rack page](https://ui.convox.com/racks/new). Here you can install Rack in your AWS account.

Name the Rack after what types of apps it will run. Common names are "dev", "staging" or "production".

Click "Install". You'll see a confirmation message the the "Rack is installing". In a few minutes you will see a status of "installed", and your Rack will be up and running.

### Connect the CLI to the Rack

First connect the `cx` command to your Convox account.

    $ cx login
    Email: user@myorg.com
    Password: *****
    Authenticating with ui.convox.com: OK

Then you can list your Racks and switch to your production Rack:

    $ cx racks
    RACKS
    myorg/production
    myorg/staging
    local

    $ cx switch myorg/staging
    OK
