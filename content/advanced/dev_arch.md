+++
title = "Development Architecture"
+++

The Convox development environment runs a few services on your computer:

* A local "router" for load balancing, DNS and SSL
* A Linux runtime via Docker
* Docker images for common resources like Postgres, Redis and RabbitMQ
* The Convox API server
