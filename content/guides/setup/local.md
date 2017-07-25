+++
title = "Local Install"
weight = 2
+++

A **Local Rack** manages apps on your computer. This makes it easy to build and run apps for development purposes.

## Install Docker

To install a local Rack you'll first need to install Docker. The free Docker Community Edition can be found for your OS [here](https://www.docker.com/community-edition).

## Install a Rack

Once you have Docker up and running you can use `cx` to install a local Rack:

    $ sudo cx rack install local
    pulling: convox/praxis:20170720082526
    installing: /Library/LaunchDaemons/convox.rack.plist
    installing: /Library/LaunchDaemons/convox.router.plist

This starts the Convox API on your computer, which the `cx` tool interacts with to manage apps.

## Router and Certificate Authority

Installing the Rack also starts a Convox Router on your computer. The router provides local DNS for the `*.convox` hostname, and offers an HTTPS endpoint for every app. This mimics the [AWS Application Load Balancer](https://aws.amazon.com/elasticloadbalancing/applicationloadbalancer/) (ALB) that Convox uses in production. The result is development-friendly hostnames like `https://web.docs.convox` for apps running on your laptops.

To eliminate a browser SSL security warning, you need to install the Convox Certificate Authority (CA) that the router users. This certificated is generated at install time, so the private key is unique to your computer.

To install the certificate:

1. Open the /Users/Shared/convox/ca.crt file

2. In the "Keychain:" dropdown select "System" and click "Add". Enter your password and click "Modify Keychain".

    ![Add Certificates](/images/add-certificates.png "Add Certificates")

3. In the "Keychain Access" window, search for "convox". You will see an untrusted root certificate authority cert.

    ![Untrusted](/images/ca-untrusted.png "Untrusted")

4. Double click on the "ca.convox" cert, then expand the "Trust" section, and for the "When using this certificate:" dropdown select "Always Trust"

    ![Always Trust](/images/always-trust.png "Always Trust")

5. Close the window. Enter your password and click "Update Settings".

6. In the "Keychain Access" window, search again for "convox". You will see that the certificate is now trusted.

    ![Trusted](/images/ca-trusted.png "Trusted")
