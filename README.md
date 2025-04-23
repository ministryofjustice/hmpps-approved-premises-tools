# Approved Premises Tools

## Overview

This project provides a tool to simplify running the HMPPS CAS UI and API projects

The tool manages local instances of the following:

* Approved Premises API - Either via docker or gradle (to run local code)
* CAS1, CAS2 or CAS3 UI - Either via docker or node (to run local code)
* Postgres - Used by the API
* Redis - Used by the UI and API
* Wiremock - Proxies all requests to upstream services, allowing us to selectively mock responses
* Localstack - Provides SQS for the API

All other upstream services (e.g. hmpps-auth, prisoner api etc.) are provided by the [Cloud Platform's](https://user-guide.cloud-platform.service.justice.gov.uk/) 'Dev' environment

We use tilt to start all required components. Tilt uses a [tiltfile](tilefile) to decide what to do, and this delegates to a [docker-compose.yml](docker-compose.yml) file for docker managed components.

As this project was created to support the approved premises project (CAS1), we refer to it as the Approved Premises Tools (AP Tools), but it is used for CAS 1, 2 & 3.

## Setup

For setup instructions, [click here](SETUP.md)

## Commands

A script that give you options for which CAS to start, and whether to run them locally, or use the latest docker container.
Check progress in the [tilt console](http://localhost:10350)
```bash
ap-tools start
```

A script to stop the ap-tools stack, which gives you the option to clear the databases.
```bash
ap-tools stop
```

Alternatively, you can type the full commands, 
```ap-tools server (start/stop) (--cas1 --local-ui --local-api / --clear-databases)```

## Accessing the User Interface

Once ap-tools has started and the [tilt console](http://localhost:10350) is all green, you can access the user interface on http://localhost:3000

## Users Credentials

The same credentials used to login to the dev instance of the CAS UIs should be used. For more information, see the [Dev & Test Users documentation](https://dsdmoj.atlassian.net/wiki/spaces/AP/pages/5624791477/Dev+Test+Users)

A [sync-secrets.sh](bin/sync-secrets.sh) script is provided to sync secrets from the secrets mastered in k8s secrets to the CAS 1Password Vault and Github Secrets (for build pipelines)

## Wiremock

All requests to upstream services are proxied by wiremock. Mocks can be configured for specific requests. For more information, [click here](./wiremock/README.md)

## Known Limitations

* We can't run all CAS UIs concurrently because auth only supports requests from localhost:3000 (i.e. we can't run each UI in different ports)
* We could solve this by installing a reverse proxy (such as traefik), but we'd need to configure that to optionally forward traffic to instances running in node, not docker
