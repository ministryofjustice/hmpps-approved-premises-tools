# Approved Premises Tools

A suite of tools to help with development on the HMPPS Approved Premises project.

## Prerequisites

* Docker
* [Tilt](https://tilt.dev/)
* [YQ](https://mikefarah.gitbook.io/yq/)
* [IntelliJ](https://www.jetbrains.com/idea/)

## Getting started

### Clone the repository

```bash
git clone git@github.com:ministryofjustice/hmpps-approved-premises-tools.git
```

### (Recommended) Install and use IntelliJ
IntelliJ is an IDE made for Java/Kotlin. It can handle dependancy downloads for Gradle 
among other things so it's recommended to install and use it. Once downloaded open each
project within it to download and check for any required dependancies.


### (Optional) Add `ap-tools` to your PATH

To add the ability to run the `ap-tools` command, you will need to add the Approved Premises Tools bin directory to your $PATH variable

Find the full path of Approved Premises Tools by changing directory into this repository, and run pwd. eg:

```bash
$ cd ~/git-clones/hmpps-approved-premises-tools
$ pwd
/Users/alex/git-clones/hmpps-approved-premises-tools
```

Add this path, plus '/bin' to the '$PATH' variable, by modifying either the ~/.bashrc or ~/.zshrc file

```bash
# ~/.bashrc or ~/.zshrc
export PATH="$PATH:/<path-to-dalmatian-tools>/bin"
```

The easiest way for this to take effect is to close and open your terminal application

Or you can run `source ~/.bashrc` or `source ~/.zshrc` on all open terminals

## Commands

### Server

This spins up all the prerequisites for running Approved Premises as Docker containers using [Tilt](https://tilt.dev/)

#### Start Server

```bash
ap-tools server start
```

Server logs will then be avaiable in the browser at http://localhost:10350

You will be able to log into the application at http://localhost:3000 with the following:

##### Delius credentials
- **Username:** `JIMSNOWLDAP`
- **Password:** `secret`

##### Nomis credentials
Take your pick from the [users seeded in nomis-user-roles-api](https://github.com/ministryofjustice/nomis-user-roles-api/blob/main/src/main/resources/db/dev/V3_1__user_data.sql)

e.g.

- **Username:** `POM_USER`
- **Password:** `password123456`

##### CAS2-specific users

###### External CAS2 Assessor
CAS2 has a group of external users from the NACRO organisation who are granted the
`CAS2_ASSESSOR` role and who have access to submitted CAS2 applications only.

- **Username:** `CAS2_ASSESSOR_USER`
- **Password:** `password123456`

###### CAS2 Management information user
CAS2 has a group of NOMIS/DPS users who need to download management information.

- **Username:** `CAS2_MI_USER`
- **Password:** `password123456`

###### CAS2 Admin
CAS2 has a group of NOMIS/DPS users who can view all submitted applications.

- **Username:** `CAS2_ADMIN_USER`
- **Password:** `password123456`

##### CRNs

There is also a usable CRN: `X320741`

##### Running local instances of the UI or API

If you need to run local instances of either the UI or API (rather than serving them from the latest Docker images), you can run add `--local-ui` or `--local-api` flags to the `start` command like so:

```bash
ap-tools server start --local-ui
```

```bash
ap-tools server start --local-api
```

```bash
ap-tools server start --local-ui --local-api
```

Note: For this to work, you must have the path to your API / UI repos set as environment variables (e.g in your `.bashrc` file), i.e:

```bash
export APPROVED_PREMISES_UI_PATH=/full/path/to/your/repo
export APPROVED_PREMISES_API_PATH=/full/path/to/your/repo
```

#### Stop Server

```bash
ap-tools server stop
```

This will stop all running `tilt` processes and tear down the entire stack.

#### Refreshing containers

Sometimes the stack will fail to come up cleanly, or you might want
to get the latest version(s) of the containers. To do this, you
can add a `--refresh` flag like so:

```bash
ap-tools server start --refresh
```
