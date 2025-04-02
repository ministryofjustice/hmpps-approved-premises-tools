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

As this project was created to support the approved premises project (CAS1), we refer to it as the Approved Premises Tools (AP Tools), but it is used for CAS 1, 2 & 3.

## Setup

### Pre-requisites

* [Kubectl configured to access the cloud platform](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/kubectl-config.html)
* [Homebrew](https://brew.sh/)
* [Docker Desktop](https://www.docker.com/products/docker-desktop/) - We have licenses available for this

If you're going to be running the API locally (i.e. not via docker), you'll need gradle and JDK 21 installed (see API project documentation)
If you're going to be running the UI locally (i.e. not via docker), you'll need node installing (see UI project documentation)

### Clone the repository

```bash
git clone https://github.com/ministryofjustice/hmpps-approved-premises-tools.git
```

### Install dependencies

```bash
/bin/install-dependencies.sh
```

### Add PATH entries

By default, the tool will run the CAS1 UI and CAS API using the latest available docker images.

When developing we typically want to run a locally built version of the UI and/or API, allowing us to quickly deploy and test changes

Clone the required project(s) e.g.

* https://github.com/ministryofjustice/hmpps-approved-premises-api
* https://github.com/ministryofjustice/hmpps-approved-premises-ui
* https://github.com/ministryofjustice/hmpps-temporary-accommodation-ui
* https://github.com/ministryofjustice/hmpps-community-accommodation-tier-2-ui

Then add the following environment variables, along with ap-tools binary path so you can run ap tools from any directory. For LOCAL_CAS_UI_PATH choose which ever UI project you are working on

```bash
export PATH="$PATH:/<path-to-approved-premises-tools>/bin"
export LOCAL_CAS_API_PATH=/Users/your-directories/hmpps-approved-premises-api
export LOCAL_CAS_UI_PATH=/Users/your-directories/hmpps-approved-premises-ui
```

For these to take effect, close and open your terminal application, or you can run  `source ~/.zshrc`

### Start ap-tools

To run using CAS1 UI and API using the latest docker images, use `ap-tools server start`

To run local versions of the configured CAS UI or the API, use `ap-tools server start --local-ui --local-api`

ap-tools uses tilt to start all required components and ensure they're in the same docker network. Tilt uses a tiltfile to decide what to do, and this delegates to a docker compose.yml file for docker managed components. You can check on the state of ap-tools by visiting the [tilt console](http://localhost:10350)

### Stop ap-tools

Ap-tools can be stopped using `ap-tools server stop`

By default, the API database will be retained across stop/start. If you'd like to remove this database, run `ap-tools server stop --clear-databases`

### Accessing the User Interface

Once ap-tools has started and the [tilt console](http://localhost:10350) is all green, you can access the user interface on http://localhost:3000

## Test Users

The same credentials used to login to the dev instance of the CAS UIs should be used. These are managed in the [CAS 1Password Vault](https://dsdmoj.atlassian.net/wiki/spaces/AP/pages/5442470559/CAS+User+Authentication+Authorisation+and+Setup)

## Wiremock

* For information on mocking specific responses, see the [wiremock README](./wiremock/README.md)
* This also includes commands to view requests/responses proxied by wiremock

## Known Limitations

* The tool only supports running CAS1 UI via docker
