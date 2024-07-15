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

### Add PATH entries for local CAS projects

The tool can run the CAS UIs and API using the locally checked out code, instead of downloading the latest published docker image

This is typically how the tool is used during development as you can quickly redeploy changes made locally for testing.

To support this, clone the API project and required UI projects e.g.

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

### Stop ap-tools

Ap-tools can be stopped using

```bash
ap-tools server stop
```

Note that by default the API database will be retained across stop/start. If you'd like to remove this database, run the following from the root of the project 

```bash
docker compose down -v
```

### Restart/Refresh components

#### Refresh Local Components

If you start ap-tools using '--local-ui', any changes you make to your ui code should be automatically applied (you can see restarts happening in the [tilt console](http://localhost:10350) when files are modified in the project)

If you start ap-tools using '--local-api', you will need to manually restart the 'local-api' component in tilt via the [tilt console](http://localhost:10350).

#### Refresh Docker Components

If you'd like to refresh docker containers to use their latest version, you can use

```bash
ap-tools server start --refresh
```

Note - this _will not_ refresh the approved-premises-and-delius component, as this is run locally via gradle

If you'd like to restart the entire tilt stack and remove the API databases, you can use the following script from the root of the project

```bash
ap-tools server stop                                       
docker compose down -v
ap-tools server start --local-ui --local-api
```

### Accessing the User Interface

Once ap-tools has started and the [tilt console](http://localhost:10350) is all green, you can access the user interface on http://localhost:3000

#### Delius credentials

We login to CAS1 and CAS3 Systems using delius credentials. Anything can be used for passwords as we mock community API authentication using wiremock, and do not check passwords

 * JIMSNOWLDAP - used that has all roles
 * NONSTAFFMEMBER - user that is not staff. shouldn't be allowed access
 * LAOFULLACCESS - user that has whitelisted (exclusion) for X400000
 * LAORESTRICTED - user that is blacklisted (restriction) for X400000
 * ApprovedPremisesTestUser - user for "Future manager" persona in E2E tests
 * SheilaHancockNPS - user for the "CRU member" persona in E2E tests

#### Nomis credentials

Take your pick from the [users seeded in nomis-user-roles-api](https://github.com/ministryofjustice/nomis-user-roles-api/blob/main/src/main/resources/db/dev/V3_1__user_data.sql)

e.g.

- **Username:** `POM_USER`
- **Password:** `password123456`

#### CAS2-specific users

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

#### CRNs

 * X320741
 * X400000 exclusion for LAOFULLACCESS (whitelist)
 * X400001 restricted from LAORESTRICTED (blacklist)

