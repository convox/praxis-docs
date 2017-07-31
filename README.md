# Convox 2.0 Documentation

Welcome to Convox, an application platform that offers perfect parity between development, testing and production environments.

This repo is home to the platform documentation, and is available online at [https://docs.convox.com/](https://docs.convox.com).

## Development

This repo also serves as an example Convox app. It is a [Hugo](https://gohugo.io/) apps that you can launch on your computer with the Convox development environment:

```bash
$ cx start
build   | building: docs
build   | Step 1/7 : FROM golang:1.8.3
build   | Step 2/7 : RUN apt-get update && apt-get install -y curl python-pip
build   | Step 3/7 : RUN pip install pygments
build   | Step 4/7 : RUN go get -v github.com/gohugoio/hugo
build   | Step 5/7 : WORKDIR /app
build   | Step 6/7 : COPY . .
build   | Step 7/7 : CMD hugo server --appendPort=false --baseURL=${HOST} --bind=0.0.0.0 -w
build   | build complete
convox  | promoting RMTLVZDQDG
convox  | starting: convox.docs.service.web.1
convox  | starting: convox.docs.service.web.2
web     | syncing: . to /app
web     | Started building sites ...
web     | 44 regular pages created
web     | Watching for changes in /app/{data,content,layouts,static,themes}
web     | Web Server is available at //web.docs.convox/ (bind address 0.0.0.0)
```

Then the app is accessable at `https://web.docs.convox` and ready to work on.

Check out the [local development walkthrough](https://docs.convox.com/walkthroughs/local/) to learn how it all works.

## Production

Then you can deploy the app to AWS by switching to a Convox production environment:

```bash
$ cx switch production
OK

$ cx deploy
build   | building: docs
Step 1/8 : FROM golang:1.8.3
...
build complete
UPDATE_IN_PROGRESS    production-docs          AWS::CloudFormation::Stack
CREATE_COMPLETE       ServiceWebTargetGroup    AWS::ElasticLoadBalancingV2::TargetGroup
CREATE_COMPLETE       ServiceWebListenerRule   AWS::ElasticLoadBalancingV2::ListenerRule
CREATE_COMPLETE       ServiceWebTasks          AWS::ECS::TaskDefinition
CREATE_COMPLETE       ServiceWeb               AWS::ECS::Service
UPDATE_COMPLETE       production-docs          AWS::CloudFormation::Stack
release promoted: RNPMYNUTQO
```

The app will be accessable behind an [AWS Application Load Balancer](https://aws.amazon.com/elasticloadbalancing/applicationloadbalancer/).

Check out the [cloud deployment walkthrough](https://docs-staging.convox.com/walkthroughs/cloud/) to learn how it all works.

## Contributing

Pull requests are welcome.

Please refer to the [Convox docs](https://docs.convox.com) for help setting up the development environment, and the [Hugo docs](https://gohugo.io/documentation/) for help with the website engine and content management.
