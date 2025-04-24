# Setup

## Pre-requisites

* [Kubectl configured to access the cloud platform](https://user-guide.cloud-platform.service.justice.gov.uk/documentation/getting-started/kubectl-config.html)
* [Homebrew](https://brew.sh/)
* [Docker Desktop](https://www.docker.com/products/docker-desktop/) - We have licenses available for this

If you're going to be running the API locally (i.e. not via docker), you'll need gradle and JDK 21 installed (see API project documentation)
If you're going to be running the UI locally (i.e. not via docker), you'll need node installing (see UI project documentation)

## Clone the repository

```bash
git clone https://github.com/ministryofjustice/hmpps-approved-premises-tools.git
```

## Install dependencies

```bash
./bin/install-dependencies.sh
```

## Add PATH entries

When developing we typically want to run a locally built version of the UI and/or API, allowing us to quickly deploy and test changes

Clone the required project(s) e.g.

* https://github.com/ministryofjustice/hmpps-approved-premises-api
* https://github.com/ministryofjustice/hmpps-approved-premises-ui
* https://github.com/ministryofjustice/hmpps-temporary-accommodation-ui
* https://github.com/ministryofjustice/hmpps-community-accommodation-tier-2-ui
* https://github.com/ministryofjustice/hmpps-community-accommodation-tier-2-bail-ui.git

Then add the following environment variables, along with ap-tools binary path so you can run ap tools from any directory.

```bash
export PATH="$PATH:/<path-to-approved-premises-tools>/bin"
export LOCAL_CAS_API_PATH=/Users/your-directories/hmpps-approved-premises-api
export LOCAL_CAS1_UI_PATH=/Users/your-directories/hmpps-approved-premises-ui
export LOCAL_CAS2_UI_PATH=/Users/your-directories/hmpps-community-accommodation-tier-2-ui
export LOCAL_CAS2V2_UI_PATH=/Users/your-directories/hmpps-community-accommodation-tier-2-bail-ui
export LOCAL_CAS3_UI_PATH=/Users/your-directories/hmpps-temporary-accommodation-ui
```

For these to take effect, close and open your terminal application, or you can run  `source ~/.zshrc`
