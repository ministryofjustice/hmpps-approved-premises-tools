# Approved Premises Tools

This project provides tools to run the HMPPS CAS Projects and their dependencies on local developer machines

As this project was created to support the approved premises project (CAS1), we refer to it as approved premises tools, but it is used for CAS1,2 & 3.

## Prerequisites

* [Homebrew](https://brew.sh/)
* [Docker Desktop](https://www.docker.com/products/docker-desktop/) - We have licenses for this
* Gradle - This is required spin up local instances of the API and approved-premises-and-delius. Can install using brew

The following will be automatically installed via brew when starting the tools

* [Tilt](https://tilt.dev/)
* [YQ](https://mikefarah.gitbook.io/yq/)

## Getting started

### Clone the repository

```bash
git clone git@github.com:ministryofjustice/hmpps-approved-premises-tools.git
```

### Install dependencies

Run

```bash
/bin/install-dependencies.sh
```

### Add PATH entries for local CAS projects

The tool can run the CAS UIs and API using the locally checked out code, instead of downloading the latest published docker image

This is typically how the tool is used during development as you can quickly redeploy changes made locally for testing.

To support this, clone the API project and required UI project(s) e.g.

* https://github.com/ministryofjustice/hmpps-approved-premises-api
* https://github.com/ministryofjustice/hmpps-approved-premises-ui
* https://github.com/ministryofjustice/hmpps-temporary-accommodation-ui
* https://github.com/ministryofjustice/hmpps-community-accommodation-tier-2-ui

Then add the path to these checked out projects in your ~/.zsrhc file:

```bash
# ~/.zshrc
export LOCAL_CAS_API_PATH=/Users/david.atkins/git-clones/hmpps-approved-premises-api
export LOCAL_CAS_UI_PATH=/Users/david.atkins/git-clones/hmpps-approved-premises-ui
```

Note! We currently only support running 1 UI at any time, populate LOCAL_CAS_UI_PATH with which ever you'd like to use

The easiest way for this to take effect is to close and open your terminal application, or you can run  `source ~/.zshrc`

### (Optional) Add `ap-tools` to your PATH

To add the ability to run the `ap-tools` command from any directory, you will need to add project directory to your $PATH variable e.g. 

```bash
# ~/.zshrc
export PATH="$PATH:/<path-to-approved-premises-tools>/bin"
```

### Start ap-tools

We typically run ap-tools passing in the '--local-api and --local-ui' arguments to run the locally cloned versions of the projects

```bash
ap-tools server start --local-ui --local-api
```

If you drop the '--local-*' arguments, the most recently published docker images will be run instead.

ap-tools uses tilt to start all required components and ensure they're in the same docker network. Tilt uses a tiltfile to decide what to do, and this delegates to a docker compose.yml file for docker managed components.

You can check on the state of ap-tools by visiting the [tilt console](http://localhost:10350) 

If this is your first time running the tools, you may see a few components fail on their first startup attempt. The [tilt console](http://localhost:10350) provides logs for each component and can be used to restart components. 

#### Start to run e2e against upstream dev services

This will seed the API database with data required to run e2e tests against upstream dev services (i.e. the API database is configured as it would be in the dev/test environments). The API will then be configured to use upstream services in dev, other than hmpps-auth

```bash
ap-tools server stop --clear-databases
ap-tools server start --local-ui --local-api-dev-upstream
```

### Stop ap-tools

Ap-tools can be stopped using

```bash
ap-tools server stop
```

Note that by default the API database will be retained across stop/start. If you'd like to remove this database, run the following from the root of the project 

```bash
ap-tools server stop --clear-databases
```

### Restart/Refresh components

#### Refresh Local Components

If you start ap-tools using '--local-ui', any changes you make to your ui code should be automatically applied (you can see restarts happening in the [tilt console](http://localhost:10350) when files are modified in the project)

If you start ap-tools using '--local-api', you will need to manually restart the 'local-api' component in tilt via the [tilt console](http://localhost:10350).

#### Refresh 3rd Party Components & Databases

When compose is started all docker containers wll be updated automatically, therefore, stop/starting ap-tools will refresh all containers

If you want to refresh already running containers, use the --refresh option

```bash
ap-tools server stop --refresh
```

If you'd like to restart the entire stack and remove all databases (including the API database), you can use the following script from the root of the project

```bash
ap-tools server stop --clear-databases     
ap-tools server start --local-ui --local-api
```

## Accessing the User Interface

Once ap-tools has started and the [tilt console](http://localhost:10350) is all green, you can access the user interface on http://localhost:3000

## Test Users

### CAS1 & CAS 3 (Delius)

We login to CAS1 and CAS3 Systems using delius credentials. Anything can be used for passwords as we mock community API authentication using wiremock, and do not check passwords

 * JIMSNOWLDAP - used that has all roles
 * NONSTAFFUSER - user that is not staff. shouldn't be allowed access
 * LAOFULLACCESS - user that has whitelisted (exclusion) for X400000
 * LAORESTRICTED - user that is blacklisted (restriction) for X400000
 * CRUWOMENSESTTATE - user that will typically be allocated the CRU Member role and Women's Estate CRU Management Area

### CAS2

#### Nomis credentials

Take your pick from the [users seeded in nomis-user-roles-api](https://github.com/ministryofjustice/nomis-user-roles-api/blob/main/src/main/resources/db/dev/V3_1__user_data.sql)

e.g.

- **Username:** `POM_USER`
- **Password:** `password123456`

##### External CAS2 Assessor

CAS2 has a group of external users from the NACRO organisation who are granted the
`CAS2_ASSESSOR` role and who have access to submitted CAS2 applications only.

- **Username:** `CAS2_ASSESSOR_USER`
- **Password:** `password123456`

##### CAS2 Management information user

CAS2 has a group of NOMIS/DPS users who need to download management information.

- **Username:** `CAS2_MI_USER`
- **Password:** `password123456`

##### CAS2 Admin

CAS2 has a group of NOMIS/DPS users who can view all submitted applications.

- **Username:** `CAS2_ADMIN_USER`
- **Password:** `password123456`

##### CAS2 Licence Case Admin

CAS2 allows Nomis users with the Licence Case Admin role to view applications for their prison.

- **Username:** `CAS2_LICENCE_USER`
- **Password:** `password123456`

## Adding / Removing Delius Users

There are several sources to consider when adding / removing / updating delius users

### HMPPS Auth (Authentication)

When logging in to CAS1 or CAS2, users are authenticated using CAS Auth. This communicates a with wiremock endpoints to authenticate the user. Therefore, to login as a user a 'HmppsAuthAndDelius_GetUser_*' JSON file must exist in wiremock/mappings for the given username

### Approved Premises and Delius API (Staff Details)

This API is used to retrieve staff details.

We can add test users via the [Data Loader](https://github.com/ministryofjustice/hmpps-probation-integration-services/blob/main/projects/approved-premises-and-delius/src/dev/kotlin/uk/gov/justice/digital/hmpps/data/DataLoader.kt). To make changes a PR must be created and reviewed by posting it to #topic-pi-cas123

Also note that if the user requires an email address, an entry also needs adding to https://github.com/ministryofjustice/hmpps-probation-integration-services/blob/main/projects/approved-premises-and-delius/src/dev/resources/schema.ldif

### Community API (Staff Details)

Note - We're in the processing of removing usage of community API to retrieve staff information in favour of the approved-premises-and-delius API. Until that's done, we need to sync our test users defined in Approved Premises and Delius API with those defined in Community PAI

Test users are managed by SQL Seed files added via /seed/community-api

### CAS API (Roles)

CAS 1 & 3 Roles are defined in the API DAtabase. For CAS1 there is a user interface to manage roles.

The CAS API will auto-populate test users with roles via

* https://github.com/ministryofjustice/hmpps-approved-premises-api/blob/main/src/main/resources/db/seed/local%2Bdev%2Btest/3__user.csv (deprecated)
* [Auto Seed Kotlin Code](https://github.com/ministryofjustice/hmpps-approved-premises-api/blob/main/src/main/kotlin/uk/gov/justice/digital/hmpps/approvedpremisesapi/seed/cas1/Cas1AutoScript.kt)

These typically align with users defined in the aforementioned sources

## Test Offender CRNs

 * X320741 (NOMS: A1234AI)
 * X400000 (NOMS: A1235AI) exclusion for LAOFULLACCESS (whitelist)
 * X400001 (NOMS: A1236AI) restricted from LAORESTRICTED (blacklist)
 * S517283 (NOMS: A1237AI) gender=Female

