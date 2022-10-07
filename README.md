# Approved Premises Tools

A suite of tools to help with development on the HMPPS Approved Premises project.

## Prerequisites

* Docker
* [Tilt](https://tilt.dev/)

## Getting started

### Clone the repository

```bash
git clone git@github.com:ministryofjustice/hmpps-approved-premises-tools.git
```

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

Username: JimSnowLdap
Password: secret

There is also a usable CRN: `X320741`

#### Stop Server

```bash
ap-tools server stop
```

This will stop all running `tilt` processes and tear down the entire stack.
