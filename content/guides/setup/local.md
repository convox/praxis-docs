+++
title = "Local Install"
weight = 2
+++

A **Local Rack** runs apps on your computer. This makes it easy to build and run apps for development purposes.

## Pre-requisites

To install a local Rack you'll first need to install Docker. The free Docker Community Edition can be found for your OS [here](https://www.docker.com/community-edition).

## Install a Rack

Once you have Docker up and running you can use `cx` to install a local Rack:

    $ sudo cx rack install local
    pulling: convox/praxis:20170720082526
    installing: /Library/LaunchDaemons/convox.rack.plist
    installing: /Library/LaunchDaemons/convox.router.plist

This starts the Convox API on your computer, which the `cx` tool interacts with to manage apps.

## Add the Certificate Authority

Installing the Rack also starts a Convox Router on your computer. The router provides local DNS for the `*.convox` hostname, and offers an HTTPS endpoint for every app. The result is development-friendly hostnames like `https://web.docs.convox` for apps running on your laptops.

To eliminate a browser SSL security warning, you need to install the Convox Certificate Authority (CA) that the router users. This certificated is generated at install time, so the private key is unique to your computer. You can load this into your keychain with:

    $ sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain /Users/Shared/convox/ca.crt

You can verify or revoke this certificate by searching for "convox" in the OS X Keychain.

![OS X Trusted Keychain Access](/images/keychain.png "OS X Trusted Keychain Access")
